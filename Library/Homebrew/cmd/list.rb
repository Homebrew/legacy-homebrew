module Homebrew extend self
  def list

    # Use of exec means we don't explicitly exit
    list_unbrewed if ARGV.flag? '--unbrewed'

    # Unbrewed uses the PREFIX, which will exist
    # Things below use the CELLAR, which doesn't until the first formula is installed.
    return unless HOMEBREW_CELLAR.exist?

    if ARGV.include? '--pinned'
      require 'formula'
      list_pinned
    elsif ARGV.include? '--versions'
      list_versions
    elsif ARGV.named.empty?
      ENV['CLICOLOR'] = nil
      exec 'ls', *ARGV.options_only << HOMEBREW_CELLAR
    elsif ARGV.verbose? or not $stdout.tty?
      exec "find", *ARGV.kegs + %w[-not -type d -print]
    else
      ARGV.kegs.each{ |keg| PrettyListing.new keg }
    end
  end

  private

  UNBREWED_EXCLUDE_FILES = %w[.DS_Store]
  UNBREWED_EXCLUDE_PATHS = %w[
    bin/brew
    lib/gdk-pixbuf-2.0/*
    lib/gio/*
    lib/node_modules/*
    lib/python[23].[0-9]/*
    share/info/dir
    share/man/man1/brew.1
    share/man/whatis
  ]

  def list_unbrewed
    dirs  = HOMEBREW_PREFIX.subdirs.map { |dir| dir.basename.to_s }
    dirs -= %w[Library Cellar .git]

    # Exclude the repository and cache, if they are located under the prefix
    dirs.delete HOMEBREW_CACHE.relative_path_from(HOMEBREW_PREFIX).to_s
    dirs.delete HOMEBREW_REPOSITORY.relative_path_from(HOMEBREW_PREFIX).to_s
    dirs.delete 'etc'
    dirs.delete 'var'

    args = dirs + %w[-type f (]
    args.concat UNBREWED_EXCLUDE_FILES.map { |f| %W[! -name #{f}] }.flatten
    args.concat UNBREWED_EXCLUDE_PATHS.map { |d| %W[! -path #{d}] }.flatten
    args.concat %w[)]

    cd HOMEBREW_PREFIX
    exec 'find', *args
  end

  def list_versions
    if ARGV.named.empty?
      HOMEBREW_CELLAR.children.select{ |pn| pn.directory? }
    else
      ARGV.named.map{ |n| HOMEBREW_CELLAR+n }.select{ |pn| pn.exist? }
    end.each do |d|
      versions = d.children.select{ |pn| pn.directory? }.map{ |pn| pn.basename.to_s }
      puts "#{d.basename} #{versions*' '}"
    end
  end

  def list_pinned
    if ARGV.named.empty?
      HOMEBREW_CELLAR.children.select{ |pn| pn.directory? }
    else
      ARGV.named.map{ |n| HOMEBREW_CELLAR+n }.select{ |pn| pn.exist? }
    end.select do |d|
      keg_pin = (HOMEBREW_LIBRARY/"PinnedKegs"/d.basename.to_s)
      keg_pin.exist? or keg_pin.symlink?
    end.each do |d|
      puts d.basename
    end
  end
end

class PrettyListing
  def initialize path
    Pathname.new(path).children.sort{ |a,b| a.to_s.downcase <=> b.to_s.downcase }.each do |pn|
      case pn.basename.to_s
      when 'bin', 'sbin'
        pn.find { |pnn| puts pnn unless pnn.directory? }
      when 'lib'
        print_dir pn do |pnn|
          # dylibs have multiple symlinks and we don't care about them
          (pnn.extname == '.dylib' or pnn.extname == '.pc') and not pnn.symlink?
        end
      else
        if pn.directory?
          if pn.symlink?
            puts "#{pn} -> #{pn.readlink}"
          else
            print_dir pn
          end
        elsif FORMULA_META_FILES.should_list? pn.basename.to_s
          puts pn
        end
      end
    end
  end

  def print_dir root
    dirs = []
    remaining_root_files = []
    other = ''

    root.children.sort.each do |pn|
      if pn.directory?
        dirs << pn
      elsif block_given? and yield pn
        puts pn
        other = 'other '
      else
        remaining_root_files << pn unless pn.basename.to_s == '.DS_Store'
      end
    end

    dirs.each do |d|
      files = []
      d.find { |pn| files << pn unless pn.directory? }
      print_remaining_files files, d
    end

    print_remaining_files remaining_root_files, root, other
  end

  def print_remaining_files files, root, other = ''
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
