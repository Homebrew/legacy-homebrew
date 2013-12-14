require 'formula'
require 'bottles'
require 'tab'
require 'keg'
require 'cmd/versions'
require 'utils/inreplace'
require 'erb'
require 'open3'
require 'extend/pathname'

class BottleMerger < Formula
  # This provides a URL and Version which are the only needed properties of
  # a Formula. This object is used to access the Formula bottle DSL to merge
  # multiple outputs of `brew bottle`.
  url '1'
  def self.reset_bottle; @bottle = Bottle.new; end
end

BOTTLE_ERB = <<-EOS
  bottle do
    <% if prefix.to_s != '/usr/local' %>
    prefix '<%= prefix %>'
    <% end %>
    <% if cellar.is_a? Symbol %>
    cellar :<%= cellar %>
    <% elsif cellar.to_s != '/usr/local/Cellar' %>
    cellar '<%= cellar %>'
    <% end %>
    <% if revision > 0 %>
    revision <%= revision %>
    <% end %>
    <% checksums.each do |checksum_type, checksum_values| %>
    <% checksum_values.each do |checksum_value| %>
    <% checksum, osx = checksum_value.shift %>
    <%= checksum_type %> '<%= checksum %>' => :<%= osx %>
    <% end %>
    <% end %>
  end
EOS

module Homebrew extend self
  class << self
    include Utils::Inreplace
  end

  def uniq_by_ino(list)
    h = {}
    list.each do |e|
      ino = e.stat.ino
      h[ino] = e unless h.key? ino
    end
    h.values
  end

  def keg_contains string, keg
    if not ARGV.homebrew_developer?
      return quiet_system 'fgrep', '--recursive', '--quiet', '--max-count=1', string, keg
    end

    # Find all files that still reference the keg via a string search
    keg_ref_files = `/usr/bin/fgrep --files-with-matches --recursive "#{string}" "#{keg}" 2>/dev/null`.split("\n")
    keg_ref_files.map! { |file| Pathname.new(file) }.reject!(&:symlink?)

    # If files are hardlinked, only check one of them
    keg_ref_files = uniq_by_ino(keg_ref_files)

    # If there are no files with that string found, return immediately
    return false if keg_ref_files.empty?

    # Start printing out each file and any extra information we can find
    opoo "String '#{string}' still exists in these files:"
    keg_ref_files.each do |file|
      puts "#{Tty.red}#{file}#{Tty.reset}"

      # Check dynamic library linkage. Importantly, do not run otool on static
      # libraries, which will falsely report "linkage" to themselves.
      if file.mach_o_executable? or file.dylib? or file.mach_o_bundle?
        linked_libraries = file.dynamically_linked_libraries
        linked_libraries = linked_libraries.select { |lib| lib.include? string }
      else
        linked_libraries = []
      end

      linked_libraries.each do |lib|
        puts " #{Tty.gray}-->#{Tty.reset} links to #{lib}"
      end

      # Use strings to search through the file for each string
      IO.popen("strings -t x - '#{file}'") do |io|
        until io.eof?
          str = io.readline.chomp

          next unless str.include? string

          offset, match = str.split(" ", 2)

          next if linked_libraries.include? match # Don't bother reporting a string if it was found by otool
          puts " #{Tty.gray}-->#{Tty.reset} match '#{match}' at offset #{Tty.em}0x#{offset}#{Tty.reset}"
        end
      end
    end
    puts
    true
  end

  def bottle_output bottle
    erb = ERB.new BOTTLE_ERB
    erb.result(bottle.instance_eval { binding }).gsub(/^\s*$\n/, '')
  end

  def bottle_formula f
    unless f.installed?
      return ofail "Formula not installed: #{f.name}"
    end

    unless built_as_bottle? f
      return ofail "Formula not installed with '--build-bottle': #{f.name}"
    end

    if ARGV.include? '--no-revision'
      bottle_revision = 0
    else
      max = f.bottle_version_map('origin/master')[f.version].max
      bottle_revision = max ? max + 1 : 0
    end

    filename = bottle_filename(f, :tag => bottle_tag, :revision => bottle_revision)

    if bottle_filename_formula_name(filename).empty?
      return ofail "Add a new regex to bottle_version.rb to parse the bottle filename."
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

        HOMEBREW_CELLAR.cd do
          # Use gzip, faster to compress than bzip2, faster to uncompress than bzip2
          # or an uncompressed tarball (and more bandwidth friendly).
          safe_system 'tar', 'czf', bottle_path, "#{f.name}/#{f.version}"
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

    bottle = Bottle.new
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

  def merge
    merge_hash = {}
    ARGV.named.each do |argument|
      formula_name = bottle_filename_formula_name argument
      merge_hash[formula_name] ||= []
      bottle_block = IO.read argument
      merge_hash[formula_name] << bottle_block
    end
    merge_hash.keys.each do |formula_name|
      BottleMerger.reset_bottle
      ohai formula_name
      bottle_blocks = merge_hash[formula_name]
      bottle_blocks.each do |bottle_block|
        BottleMerger.class_eval bottle_block
      end
      bottle = BottleMerger.new.bottle
      next unless bottle
      output = bottle_output bottle
      puts output

      if ARGV.include? '--write'
        f = Formula.factory formula_name
        formula_relative_path = "Library/Formula/#{f.name}.rb"
        formula_path = HOMEBREW_REPOSITORY+formula_relative_path
        has_bottle_block = f.class.send(:bottle).checksums.any?
        inreplace formula_path do |s|
          if has_bottle_block
            s.sub!(/  bottle do.+?end\n/m, output)
          else
            s.sub!(/(  (url|sha1|head|version) '\S*'\n+)+/m, '\0' + output + "\n")
          end
        end

        update_or_add = has_bottle_block ? 'update' : 'add'

        safe_system 'git', 'commit', '--no-edit', '--verbose',
          "--message=#{f.name}: #{update_or_add} #{f.version} bottle.",
          '--', formula_path
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
