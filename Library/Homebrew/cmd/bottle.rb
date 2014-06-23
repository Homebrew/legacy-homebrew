require 'formula'
require 'bottles'
require 'tab'
require 'keg'
require 'formula_versions'
require 'utils/inreplace'
require 'erb'
require 'extend/pathname'

BOTTLE_ERB = <<-EOS
  bottle do
    <% if root_url != BottleSpecification::DEFAULT_ROOT_URL %>
    root_url "<%= root_url %>"
    <% end %>
    <% if prefix.to_s != "/usr/local" %>
    prefix "<%= prefix %>"
    <% end %>
    <% if cellar.is_a? Symbol %>
    cellar :<%= cellar %>
    <% elsif cellar.to_s != "/usr/local/Cellar" %>
    cellar "<%= cellar %>"
    <% end %>
    <% if revision > 0 %>
    revision <%= revision %>
    <% end %>
    <% checksums.each do |checksum_type, checksum_values| %>
    <% checksum_values.each do |checksum_value| %>
    <% checksum, osx = checksum_value.shift %>
    <%= checksum_type %> "<%= checksum %>" => :<%= osx %>
    <% end %>
    <% end %>
  end
EOS

module Homebrew
  def keg_contains string, keg
    if not ARGV.homebrew_developer?
      return quiet_system 'fgrep', '--recursive', '--quiet', '--max-count=1', string, keg
    end

    result = false
    index = 0

    keg.each_unique_file_matching(string) do |file|
      if ARGV.verbose?
        opoo "String '#{string}' still exists in these files:" if index.zero?
        puts "#{Tty.red}#{file}#{Tty.reset}"
      end

      # Check dynamic library linkage. Importantly, do not run otool on static
      # libraries, which will falsely report "linkage" to themselves.
      if file.mach_o_executable? or file.dylib? or file.mach_o_bundle?
        linked_libraries = file.dynamically_linked_libraries
        linked_libraries = linked_libraries.select { |lib| lib.include? string }
      else
        linked_libraries = []
      end

      if ARGV.verbose?
        linked_libraries.each do |lib|
          puts " #{Tty.gray}-->#{Tty.reset} links to #{lib}"
        end
      end

      # Use strings to search through the file for each string
      IO.popen("strings -t x - '#{file}'", "rb") do |io|
        until io.eof?
          str = io.readline.chomp

          next unless str.include? string

          offset, match = str.split(" ", 2)

          next if linked_libraries.include? match # Don't bother reporting a string if it was found by otool
          if ARGV.verbose?
            puts " #{Tty.gray}-->#{Tty.reset} match '#{match}' at offset #{Tty.em}0x#{offset}#{Tty.reset}"
          end
        end
      end

      index += 1
      result = true
    end

    index = 0
    keg.find do |pn|
      if pn.symlink? && (link = pn.readlink).absolute?
        if link.to_s.start_with?(string)
          opoo "Absolute symlink starting with #{string}:" if index.zero?
          puts "  #{pn} -> #{pn.resolved_path}"
        end

        index += 1
        result = true
      end
    end

    result
  end

  def bottle_output bottle
    erb = ERB.new BOTTLE_ERB
    erb.result(bottle.instance_eval { binding }).gsub(/^\s*$\n/, '')
  end

  def bottle_formula f
    unless f.installed?
      return ofail "Formula not installed or up-to-date: #{f.name}"
    end

    unless built_as_bottle? f
      return ofail "Formula not installed with '--build-bottle': #{f.name}"
    end

    unless f.stable
      return ofail "Formula has no stable version: #{f.name}"
    end

    if ARGV.include? '--no-revision'
      bottle_revision = 0
    else
      ohai "Determining #{f.name} bottle revision..."
      versions = FormulaVersions.new(f)
      max = versions.bottle_version_map("origin/master")[f.pkg_version].max
      bottle_revision = max ? max + 1 : 0
    end

    filename = bottle_filename(
      :name => f.name,
      :version => f.pkg_version,
      :revision => bottle_revision,
      :tag => bottle_tag
    )

    if bottle_filename_formula_name(filename).empty?
      return ofail "Add a new regex to bottle_version.rb to parse #{f.version} from #{filename}"
    end

    bottle_path = Pathname.pwd/filename

    prefix = HOMEBREW_PREFIX.to_s
    cellar = HOMEBREW_CELLAR.to_s

    ohai "Bottling #{filename}..."

    keg = Keg.new(f.prefix)
    relocatable = false

    keg.lock do
      begin
        keg.relocate_install_names prefix, Keg::PREFIX_PLACEHOLDER,
          cellar, Keg::CELLAR_PLACEHOLDER, :keg_only => f.keg_only?
        keg.delete_pyc_files!

        HOMEBREW_CELLAR.cd do
          # Use gzip, faster to compress than bzip2, faster to uncompress than bzip2
          # or an uncompressed tarball (and more bandwidth friendly).
          safe_system 'tar', 'czf', bottle_path, "#{f.name}/#{f.pkg_version}"
        end

        if File.size?(bottle_path) > 1*1024*1024
          ohai "Detecting if #{filename} is relocatable..."
        end

        if prefix == '/usr/local'
          prefix_check = HOMEBREW_PREFIX/'opt'
        else
          prefix_check = HOMEBREW_PREFIX
        end

        relocatable = !keg_contains(prefix_check, keg)
        relocatable = !keg_contains(HOMEBREW_CELLAR, keg) && relocatable
        puts if !relocatable && ARGV.verbose?
      rescue Interrupt
        ignore_interrupts { bottle_path.unlink if bottle_path.exist? }
        raise
      ensure
        ignore_interrupts do
          keg.relocate_install_names Keg::PREFIX_PLACEHOLDER, prefix,
            Keg::CELLAR_PLACEHOLDER, cellar, :keg_only => f.keg_only?
        end
      end
    end

    root_url = ARGV.value("root_url")

    bottle = BottleSpecification.new
    bottle.root_url(root_url) if root_url
    bottle.prefix HOMEBREW_PREFIX
    bottle.cellar relocatable ? :any : HOMEBREW_CELLAR
    bottle.revision bottle_revision
    bottle.sha1 bottle_path.sha1 => bottle_tag

    output = bottle_output bottle

    puts "./#{filename}"
    puts output

    if ARGV.include? '--rb'
      bottle_base = filename.gsub(bottle_suffix(bottle_revision), '')
      File.open "#{bottle_base}.bottle.rb", 'w' do |file|
        file.write output
      end
    end
  end

  module BottleMerger
    def bottle(&block)
      instance_eval(&block)
    end
  end

  def merge
    merge_hash = {}
    ARGV.named.each do |argument|
      formula_name = bottle_filename_formula_name argument
      merge_hash[formula_name] ||= []
      bottle_block = IO.read argument
      merge_hash[formula_name] << bottle_block
    end

    merge_hash.each do |formula_name, bottle_blocks|
      ohai formula_name

      bottle = BottleSpecification.new.extend(BottleMerger)
      bottle_blocks.each { |block| bottle.instance_eval(block) }

      output = bottle_output bottle
      puts output

      if ARGV.include? '--write'
        f = Formulary.factory(formula_name)
        update_or_add = nil

        Utils::Inreplace.inreplace(f.path) do |s|
          if s.include? 'bottle do'
            update_or_add = 'update'
            string = s.sub!(/  bottle do.+?end\n/m, output)
            odie 'Bottle block update failed!' unless string
          else
            update_or_add = 'add'
            string = s.sub!(/(  (url|sha1|sha256|head|version|mirror) ['"][\S ]+['"]\n+)+/m, '\0' + output + "\n")
            odie 'Bottle block addition failed!' unless string
          end
        end

        version = f.version.to_s
        version += "_#{f.revision}" if f.revision.to_i > 0

        HOMEBREW_REPOSITORY.cd do
          safe_system "git", "commit", "--no-edit", "--verbose",
            "--message=#{f.name}: #{update_or_add} #{version} bottle.",
            "--", f.path
        end
      end
    end
    exit 0
  end

  def bottle
    merge if ARGV.include? '--merge'

    ARGV.formulae.each do |f|
      bottle_formula f
    end
  end
end
