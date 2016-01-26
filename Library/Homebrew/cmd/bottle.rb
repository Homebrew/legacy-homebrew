require "formula"
require "bottles"
require "tab"
require "keg"
require "formula_versions"
require "utils/inreplace"
require "erb"
require "extend/pathname"

BOTTLE_ERB = <<-EOS
  bottle do
    <% if !root_url.start_with?(BottleSpecification::DEFAULT_DOMAIN) %>
    root_url "<%= root_url %>"
    <% end %>
    <% if prefix != BottleSpecification::DEFAULT_PREFIX %>
    prefix "<%= prefix %>"
    <% end %>
    <% if cellar.is_a? Symbol %>
    cellar :<%= cellar %>
    <% elsif cellar != BottleSpecification::DEFAULT_CELLAR %>
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

MAXIMUM_STRING_MATCHES = 100

module Homebrew
  def keg_contains(string, keg, ignores)
    @put_string_exists_header, @put_filenames = nil

    def print_filename(string, filename)
      unless @put_string_exists_header
        opoo "String '#{string}' still exists in these files:"
        @put_string_exists_header = true
      end

      @put_filenames ||= []
      unless @put_filenames.include? filename
        puts "#{Tty.red}#{filename}#{Tty.reset}"
        @put_filenames << filename
      end
    end

    result = false

    keg.each_unique_file_matching(string) do |file|
      # skip document file.
      next if Metafiles::EXTENSIONS.include? file.extname

      # Check dynamic library linkage. Importantly, do not run otool on static
      # libraries, which will falsely report "linkage" to themselves.
      if file.mach_o_executable? || file.dylib? || file.mach_o_bundle?
        linked_libraries = file.dynamically_linked_libraries
        linked_libraries = linked_libraries.select { |lib| lib.include? string }
        result ||= linked_libraries.any?
      else
        linked_libraries = []
      end

      if ARGV.verbose?
        print_filename(string, file) if linked_libraries.any?
        linked_libraries.each do |lib|
          puts " #{Tty.gray}-->#{Tty.reset} links to #{lib}"
        end
      end

      text_matches = []

      # Use strings to search through the file for each string
      Utils.popen_read("strings", "-t", "x", "-", file.to_s) do |io|
        until io.eof?
          str = io.readline.chomp
          next if ignores.any? { |i| i =~ str }
          next unless str.include? string
          offset, match = str.split(" ", 2)
          next if linked_libraries.include? match # Don't bother reporting a string if it was found by otool

          result = true
          text_matches << [match, offset]
        end
      end

      if ARGV.verbose? && text_matches.any?
        print_filename string, file
        text_matches.first(MAXIMUM_STRING_MATCHES).each do |match, offset|
          puts " #{Tty.gray}-->#{Tty.reset} match '#{match}' at offset #{Tty.em}0x#{offset}#{Tty.reset}"
        end

        if text_matches.size > MAXIMUM_STRING_MATCHES
          puts "Only the first #{MAXIMUM_STRING_MATCHES} matches were output"
        end
      end
    end

    absolute_symlinks_start_with_string = []
    absolute_symlinks_rest = []
    keg.find do |pn|
      if pn.symlink? && (link = pn.readlink).absolute?
        if link.to_s.start_with?(string)
          absolute_symlinks_start_with_string << pn
        else
          absolute_symlinks_rest << pn
        end

        result = true
      end
    end

    if ARGV.verbose?
      if absolute_symlinks_start_with_string.any?
        opoo "Absolute symlink starting with #{string}:"
        absolute_symlinks_start_with_string.each do |pn|
          puts "  #{pn} -> #{pn.resolved_path}"
        end
      end

      if absolute_symlinks_rest.any?
        opoo "Absolute symlink:"
        absolute_symlinks_rest.each do |pn|
          puts "  #{pn} -> #{pn.resolved_path}"
        end
      end
    end

    result
  end

  def bottle_output(bottle)
    erb = ERB.new BOTTLE_ERB
    erb.result(bottle.instance_eval { binding }).gsub(/^\s*$\n/, "")
  end

  def bottle_formula(f)
    unless f.installed?
      return ofail "Formula not installed or up-to-date: #{f.full_name}"
    end

    unless f.tap
      return ofail "Formula not from core or any taps: #{f.full_name}"
    end

    if f.bottle_disabled?
      ofail "Formula has disabled bottle: #{f.full_name}"
      puts f.bottle_disable_reason
      return
    end

    unless built_as_bottle? f
      return ofail "Formula not installed with '--build-bottle': #{f.full_name}"
    end

    unless f.stable
      return ofail "Formula has no stable version: #{f.full_name}"
    end

    if ARGV.include? "--no-revision"
      bottle_revision = 0
    elsif ARGV.include? "--keep-old"
      bottle_revision = f.bottle_specification.revision
    else
      ohai "Determining #{f.full_name} bottle revision..."
      versions = FormulaVersions.new(f)
      bottle_revisions = versions.bottle_version_map("origin/master")[f.pkg_version]
      bottle_revisions.pop if bottle_revisions.last.to_i > 0
      bottle_revision = bottle_revisions.any? ? bottle_revisions.max.to_i + 1 : 0
    end

    filename = Bottle::Filename.create(f, bottle_tag, bottle_revision)
    bottle_path = Pathname.pwd/filename

    tar_filename = filename.to_s.sub(/.gz$/, "")
    tar_path = Pathname.pwd/tar_filename

    prefix = HOMEBREW_PREFIX.to_s
    cellar = HOMEBREW_CELLAR.to_s

    ohai "Bottling #{filename}..."

    keg = Keg.new(f.prefix)
    relocatable = false
    skip_relocation = false

    keg.lock do
      original_tab = nil

      begin
        keg.relocate_install_names prefix, Keg::PREFIX_PLACEHOLDER,
          cellar, Keg::CELLAR_PLACEHOLDER
        keg.relocate_text_files prefix, Keg::PREFIX_PLACEHOLDER,
          cellar, Keg::CELLAR_PLACEHOLDER

        keg.delete_pyc_files!

        tab = Tab.for_keg(keg)
        original_tab = tab.dup
        tab.poured_from_bottle = false
        tab.HEAD = nil
        tab.time = nil
        tab.write

        keg.find {|k| File.utime(File.atime(k), tab.source_modified_time, k) }

        cd cellar do
          safe_system "tar", "cf", tar_path, "#{f.name}/#{f.pkg_version}"
          File.utime(File.atime(tar_path), tab.source_modified_time, tar_path)
          relocatable_tar_path = "#{f}-bottle.tar"
          mv tar_path, relocatable_tar_path
          # Use gzip, faster to compress than bzip2, faster to uncompress than bzip2
          # or an uncompressed tarball (and more bandwidth friendly).
          safe_system "gzip", "-f", relocatable_tar_path
          mv "#{relocatable_tar_path}.gz", bottle_path
        end

        if bottle_path.size > 1*1024*1024
          ohai "Detecting if #{filename} is relocatable..."
        end

        if prefix == "/usr/local"
          prefix_check = File.join(prefix, "opt")
        else
          prefix_check = prefix
        end

        ignores = []
        if f.deps.any? { |dep| dep.name == "go" }
          ignores << %r{#{HOMEBREW_CELLAR}/go/[\d\.]+/libexec}
        end

        relocatable = !keg_contains(prefix_check, keg, ignores)
        relocatable = !keg_contains(cellar, keg, ignores) && relocatable
        skip_relocation = relocatable && !keg.require_install_name_tool?
        puts if !relocatable && ARGV.verbose?
      rescue Interrupt
        ignore_interrupts { bottle_path.unlink if bottle_path.exist? }
        raise
      ensure
        ignore_interrupts do
          original_tab.write
          keg.relocate_install_names Keg::PREFIX_PLACEHOLDER, prefix,
            Keg::CELLAR_PLACEHOLDER, cellar
          keg.relocate_text_files Keg::PREFIX_PLACEHOLDER, prefix,
            Keg::CELLAR_PLACEHOLDER, cellar
        end
      end
    end

    root_url = ARGV.value("root-url")
    # Use underscored version for legacy reasons. Remove at some point.
    root_url ||= ARGV.value("root_url")

    bottle = BottleSpecification.new
    bottle.root_url(root_url) if root_url
    if relocatable
      if skip_relocation
        bottle.cellar :any_skip_relocation
      else
        bottle.cellar :any
      end
    else
      bottle.cellar cellar
      bottle.prefix prefix
    end
    bottle.revision bottle_revision
    bottle.sha256 bottle_path.sha256 => bottle_tag

    old_spec = f.bottle_specification
    if ARGV.include?("--keep-old") && !old_spec.checksums.empty?
      bad_fields = [:root_url, :prefix, :cellar, :revision].select do |field|
        old_spec.send(field) != bottle.send(field)
      end
      bad_fields.delete(:cellar) if old_spec.cellar == :any && bottle.cellar == :any_skip_relocation
      if bad_fields.any?
        bottle_path.unlink if bottle_path.exist?
        odie "--keep-old is passed but there are changes in: #{bad_fields.join ", "}"
      end
    end

    output = bottle_output bottle

    puts "./#{filename}"
    puts output

    if ARGV.include? "--rb"
      File.open("#{filename.prefix}.bottle.rb", "w") do |file|
        file.write("\# #{f.full_name}\n")
        file.write(output)
      end
    end
  end

  module BottleMerger
    def bottle(&block)
      instance_eval(&block)
    end
  end

  def merge
    write = ARGV.include? "--write"
    keep_old = ARGV.include? "--keep-old"

    merge_hash = {}
    ARGV.named.each do |argument|
      bottle_block = IO.read(argument)
      formula_name = bottle_block.lines.first.sub(/^# /, "").chomp
      merge_hash[formula_name] ||= []
      merge_hash[formula_name] << bottle_block
    end

    merge_hash.each do |formula_name, bottle_blocks|
      ohai formula_name
      f = Formulary.factory(formula_name)

      if f.bottle_disabled?
        ofail "Formula #{f.full_name} has disabled bottle"
        puts f.bottle_disable_reason
        next
      end

      bottle = if keep_old
        f.bottle_specification.dup
      else
        BottleSpecification.new
      end
      bottle.extend(BottleMerger)
      bottle_blocks.each { |block| bottle.instance_eval(block) }

      old_spec = f.bottle_specification
      if keep_old && !old_spec.checksums.empty?
         bad_fields = [:root_url, :prefix, :cellar, :revision].select do |field|
           old_spec.send(field) != bottle.send(field)
         end
         bad_fields.delete(:cellar) if old_spec.cellar == :any && bottle.cellar == :any_skip_relocation
         if bad_fields.any?
           ofail "--keep-old is passed but there are changes in: #{bad_fields.join ", "}"
           next
         end
      end

      output = bottle_output bottle
      puts output

      if write
        update_or_add = nil

        Utils::Inreplace.inreplace(f.path) do |s|
          if s.include? "bottle do"
            update_or_add = "update"
            string = s.sub!(/  bottle do.+?end\n/m, output)
            odie "Bottle block update failed!" unless string
          else
            update_or_add = "add"
            if s.include? "stable do"
              indent = s.slice(/^ +stable do/).length - "stable do".length
              string = s.sub!(/^ {#{indent}}stable do(.|\n)+?^ {#{indent}}end\n/m, '\0' + output + "\n")
            else
              string = s.sub!(
                /(
                  \ {2}(                                                         # two spaces at the beginning
                    (url|head)\ ['"][\S\ ]+['"]                                  # url or head with a string
                    (
                      ,[\S\ ]*$                                                  # url may have options
                      (\n^\ {3}[\S\ ]+$)*                                        # options can be in multiple lines
                    )?|
                    (homepage|desc|sha1|sha256|version|mirror)\ ['"][\S\ ]+['"]| # specs with a string
                    revision\ \d+                                                # revision with a number
                  )\n+                                                           # multiple empty lines
                 )+
               /mx, '\0' + output + "\n")
            end
            odie "Bottle block addition failed!" unless string
          end
        end

        unless ARGV.include? "--no-commit"
          f.path.parent.cd do
            safe_system "git", "commit", "--no-edit", "--verbose",
              "--message=#{f.name}: #{update_or_add} #{f.pkg_version} bottle.",
              "--", f.path
          end
        end
      end
    end
  end

  def bottle
    if ARGV.include? "--merge"
      merge
    else
      ARGV.resolved_formulae.each do |f|
        bottle_formula f
      end
    end
  end
end
