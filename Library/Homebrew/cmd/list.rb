require "metafiles"
require "formula"

module Homebrew
  def list
    # Use of exec means we don't explicitly exit
    list_unbrewed if ARGV.flag? "--unbrewed"

    # Unbrewed uses the PREFIX, which will exist
    # Things below use the CELLAR, which doesn't until the first formula is installed.
    unless HOMEBREW_CELLAR.exist?
      raise NoSuchKegError.new(ARGV.named.first) if ARGV.named.any?
      return
    end

    if ARGV.include?("--pinned") || ARGV.include?("--versions")
      filtered_list
    elsif ARGV.named.empty?
      if ARGV.include? "--full-name"
        full_names = Formula.installed.map(&:full_name).sort do |a, b|
          if a.include?("/") && !b.include?("/")
            1
          elsif !a.include?("/") && b.include?("/")
            -1
          else
            a <=> b
          end
        end
        puts_columns full_names
      else
        ENV["CLICOLOR"] = nil
        exec "ls", *ARGV.options_only << HOMEBREW_CELLAR
      end
    elsif ARGV.verbose? || !$stdout.tty?
      exec "find", *ARGV.kegs.map(&:to_s) + %w[-not -type d -print]
    else
      ARGV.kegs.each { |keg| PrettyListing.new keg }
    end
  end

  private

  UNBREWED_EXCLUDE_FILES = %w[.DS_Store]
  UNBREWED_EXCLUDE_PATHS = %w[
    .github/*
    bin/brew
    lib/gdk-pixbuf-2.0/*
    lib/gio/*
    lib/node_modules/*
    lib/python[23].[0-9]/*
    lib/pypy/*
    lib/pypy3/*
    lib/ruby/gems/[12].*
    lib/ruby/site_ruby/[12].*
    lib/ruby/vendor_ruby/[12].*
    share/pypy/*
    share/pypy3/*
    share/doc/homebrew/*
    share/info/dir
    share/man/man1/brew.1
    share/man/whatis
  ]

  def list_unbrewed
    dirs  = HOMEBREW_PREFIX.subdirs.map { |dir| dir.basename.to_s }
    dirs -= %w[Library Cellar .git]

    # Exclude cache, logs, and repository, if they are located under the prefix.
    [HOMEBREW_CACHE, HOMEBREW_LOGS, HOMEBREW_REPOSITORY].each do |dir|
      dirs.delete dir.relative_path_from(HOMEBREW_PREFIX).to_s
    end
    dirs.delete "etc"
    dirs.delete "var"

    args = dirs + %w[-type f (]
    args.concat UNBREWED_EXCLUDE_FILES.flat_map { |f| %W[! -name #{f}] }
    args.concat UNBREWED_EXCLUDE_PATHS.flat_map { |d| %W[! -path #{d}] }
    args.concat %w[)]

    cd HOMEBREW_PREFIX
    exec "find", *args
  end

  def filtered_list
    names = if ARGV.named.empty?
      Formula.racks
    else
      ARGV.named.map { |n| HOMEBREW_CELLAR+n }.select(&:exist?)
    end
    if ARGV.include? "--pinned"
      pinned_versions = {}
      names.each do |d|
        keg_pin = (HOMEBREW_LIBRARY/"PinnedKegs"/d.basename.to_s)
        if keg_pin.exist? || keg_pin.symlink?
          pinned_versions[d] = keg_pin.readlink.basename.to_s
        end
      end
      pinned_versions.each do |d, version|
        puts "#{d.basename}".concat(ARGV.include?("--versions") ? " #{version}" : "")
      end
    else # --versions without --pinned
      names.each do |d|
        versions = d.subdirs.map { |pn| pn.basename.to_s }
        next if ARGV.include?("--multiple") && versions.length < 2
        puts "#{d.basename} #{versions*" "}"
      end
    end
  end
end

class PrettyListing
  def initialize(path)
    Pathname.new(path).children.sort_by { |p| p.to_s.downcase }.each do |pn|
      case pn.basename.to_s
      when "bin", "sbin"
        pn.find { |pnn| puts pnn unless pnn.directory? }
      when "lib"
        print_dir pn do |pnn|
          # dylibs have multiple symlinks and we don't care about them
          (pnn.extname == ".dylib" || pnn.extname == ".pc") && !pnn.symlink?
        end
      else
        if pn.directory?
          if pn.symlink?
            puts "#{pn} -> #{pn.readlink}"
          else
            print_dir pn
          end
        elsif Metafiles.list?(pn.basename.to_s)
          puts pn
        end
      end
    end
  end

  def print_dir(root)
    dirs = []
    remaining_root_files = []
    other = ""

    root.children.sort.each do |pn|
      if pn.directory?
        dirs << pn
      elsif block_given? && yield(pn)
        puts pn
        other = "other "
      else
        remaining_root_files << pn unless pn.basename.to_s == ".DS_Store"
      end
    end

    dirs.each do |d|
      files = []
      d.find { |pn| files << pn unless pn.directory? }
      print_remaining_files files, d
    end

    print_remaining_files remaining_root_files, root, other
  end

  def print_remaining_files(files, root, other = "")
    case files.length
    when 0
      # noop
    when 1
      puts files
    else
      puts "#{root}/ (#{files.length} #{other}files)"
    end
  end
end
