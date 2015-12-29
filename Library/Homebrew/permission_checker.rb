#!/usr/bin/env ruby

require "pathname"

# {PermissionChecker} is used to check and fix permission problems in user's filesystem.
class PermissionChecker
  CHECK_LIST = {
    :file => %w[
      $HOMEBREW_REPOSITORY/bin/brew
      $HOMEBREW_REPOSITORY/share/man/man1/brew.1
      $HOMEBREW_REPOSITORY/.gitignore
      $HOMEBREW_REPOSITORY/.travis.yml
      $HOMEBREW_REPOSITORY/.yardopts
      $HOMEBREW_REPOSITORY/CODEOFCONDUCT.md
      $HOMEBREW_REPOSITORY/CONTRIBUTING.md
      $HOMEBREW_REPOSITORY/LICENSE.txt
      $HOMEBREW_REPOSITORY/README.md
      $HOMEBREW_REPOSITORY/SUPPORTERS.md
    ],
    :directory => %w[
      $HOMEBREW_PREFIX
      $HOMEBREW_PREFIX/Frameworks
      $HOMEBREW_PREFIX/bin
      $HOMEBREW_PREFIX/etc
      $HOMEBREW_PREFIX/include
      $HOMEBREW_PREFIX/lib
      $HOMEBREW_PREFIX/lib/pkgconfig
      $HOMEBREW_PREFIX/lib/python*/site-packages
      $HOMEBREW_PREFIX/opt
      $HOMEBREW_PREFIX/sbin
      $HOMEBREW_PREFIX/share
      $HOMEBREW_PREFIX/var
      $HOMEBREW_PREFIX/var/log
      $HOMEBREW_PREFIX/share/info
      $HOMEBREW_PREFIX/share/doc
      $HOMEBREW_PREFIX/share/aclocal
      $HOMEBREW_REPOSITORY
      $HOMEBREW_REPOSITORY/Library
    ],
    :directory_recursive => %w[
      $HOMEBREW_CACHE
      $HOMEBREW_CELLAR
      $HOMEBREW_LOGS
      $HOMEBREW_PREFIX/share/locale
      $HOMEBREW_PREFIX/share/man
      $HOMEBREW_REPOSITORY/Library/Taps
    ],
    :directory_recursive_include_file => %w[
     $HOMEBREW_REPOSITORY/Library/ENV
     $HOMEBREW_REPOSITORY/Library/Homebrew
     $HOMEBREW_REPOSITORY/share/doc/homebrew
    ],
    :directory_ensure_existence => %w[
     $HOMEBREW_CACHE
     $HOMEBREW_PREFIX
    ]
  }

  # paths to check
  attr_reader :paths_to_check

  # paths need to be `chmod`
  attr_reader :chmods

  # paths need to be `chmown`
  attr_reader :chowns

  # paths need to be `chgrp`
  attr_reader :chgrps

  # directories need to be created
  attr_reader :missing_dirs

  def initialize
    @paths_to_check = []
    @paths_to_check += CHECK_LIST.fetch(:file, []).map { |p| expand_path(p) }.flatten.select(&:file?)
    @paths_to_check += CHECK_LIST.fetch(:directory, []).map { |p| expand_path(p) }.flatten.select(&:directory?)
    CHECK_LIST.fetch(:directory_recursive, []).map { |p| expand_path(p) }.flatten.each do |p|
      next unless p.directory?
      p.find do |subpath|
        @paths_to_check << subpath if subpath.directory?
      end
    end
    CHECK_LIST.fetch(:directory_recursive_include_file, []).map { |p| expand_path(p) }.flatten.each do |p|
      next unless p.directory?
      p.find do |subpath|
        @paths_to_check << subpath if subpath.exist? # check exist to skip broken symlink
      end
    end
    @paths_to_check.uniq!

    @missing_dirs = CHECK_LIST.fetch(:directory_ensure_existence, []).map do |p|
      p = translate_path(p)
      p unless p.directory?
    end.compact
  end

  # check the permission problems
  def check!
    @chmods = []
    @chowns = []
    @chgrps = []

    @paths_to_check.each do |p|
      if p.directory?
        @chmods << p unless p.readable? && p.writable? && p.executable?
      else
        @chmods << p unless p.readable? && p.writable?
      end

      @chowns << p unless p.owned?
      @chgrps << p unless p.grpowned?
    end

    @chmods.empty? && @chowns.empty? && @chgrps.empty? && @missing_dirs.empty?
  end

  # fix the permission problems
  def fix!
    return if check!

    @chmods.each do |p|
      if p.directory?
        sudo "/bin/chmod", "g+rwx,u+rwx", p
      else
        sudo "/bin/chmod", "g+rw,u+rw", p
      end
    end
    @chowns.each { |p| sudo "/usr/sbin/chown", ENV["USER"], p }
    @chgrps.each { |p| sudo "/usr/bin/chgrp", "#{ENV["USER"]}:admin", p }
    @missing_dirs.each do |p|
      sudo "/bin/mkdir", p
      sudo "/bin/chmod", "g+rwx,u+rwx", p
      sudo "/usr/sbin/chown", ENV["USER"], p
      sudo "/usr/bin/chgrp", "#{ENV["USER"]}:admin", p
    end
  ensure
    sudo "-k"
  end

  # generate the permission problems report.
  # @param [String] verb the verb used in report. Default is `should`.
  def report(verb="should")
    str = ""

    unless @chmods.empty?
      str << "The following files #{verb} be made group writable:\n"
      @chmods.inject(str) { |s, p| s << "    #{p}\n"}
      str << "\n"
    end

    unless @chowns.empty?
      str << "The following files #{verb} have their owner set to #{ENV["USER"]}:\n"
      @chowns.inject(str) { |s, p| s << "    #{p}\n"}
      str << "\n"
    end

    unless @chgrps.empty?
      str << "The following files #{verb} have their group set to admin:\n"
      @chgrps.inject(str) { |s, p| s << "    #{p}\n"}
      str << "\n"
    end

    unless @missing_dirs.empty?
      str << "The following directories #{verb} be created:\n"
      @missing_dirs.inject(str) { |s, p| s << "    #{p}\n"}
      str << "\n"
    end

    str
  end

  private
  def translate_path(path)
    path.sub!("$HOMEBREW_CACHE", HOMEBREW_CACHE)
    path.sub!("$HOMEBREW_CELLAR", HOMEBREW_CELLAR)
    path.sub!("$HOMEBREW_LOGS", HOMEBREW_LOGS)
    path.sub!("$HOMEBREW_PREFIX", HOMEBREW_PREFIX)
    path.sub!("$HOMEBREW_REPOSITORY", HOMEBREW_REPOSITORY)
    Pathname.new(path)
  end

  def expand_path(path)
    Pathname.glob(translate_path(path))
  end

  def sudo(*args)
    ohai "/usr/bin/sudo #{args.join " "}"
    system "/usr/bin/sudo", *args
  end
end

# Run this file as a standalone script. This is invoked as part of install script.
# Various of Homebrew related paths are required to set as environment.
#
# Usage:
#    permission_checker.rb --fix
#       To fix the permission problems.
#
#    permission_checker.rb [--verb=<verb>]
#       To check the permission problems and output report.
#       Optional verb for report can be provide.
if __FILE__ == $PROGRAM_NAME
  %w[
    HOMEBREW_CACHE HOMEBREW_CELLAR HOMEBREW_LOGS
    HOMEBREW_PREFIX HOMEBREW_REPOSITORY
  ].each do |var|
    if ENV[var]
      PermissionChecker.const_set(var, ENV[var])
    else
      raise "Environment variable #{var} is missing"
    end
  end
  checker = PermissionChecker.new
  if ARGV.include? "--fix"
    checker.fix!
  else
    checker.check! && exit
    verb = ARGV.find { |o| o =~ /--verb=(.+)/ } ? $1 : "should"
    puts checker.report(verb)
    exit(1)
  end
end
