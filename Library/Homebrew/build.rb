# This script is loaded by formula_installer as a separate instance.
# Thrown exceptions are propogated back to the parent process over a pipe

STD_TRAP = trap("INT") { exit! 130 } # no backtrace thanks

at_exit { main }

require 'global'
require 'cxxstdlib'
require 'debrew' if ARGV.debug?

def main
  # The main Homebrew process expects to eventually see EOF on the error
  # pipe in FormulaInstaller#build. However, if any child process fails to
  # terminate (i.e, fails to close the descriptor), this won't happen, and
  # the installer will hang. Set close-on-exec to prevent this.
  # Whether it is *wise* to launch daemons from formulae is a separate
  # question altogether.
  if ENV['HOMEBREW_ERROR_PIPE']
    require 'fcntl'
    error_pipe = IO.new(ENV['HOMEBREW_ERROR_PIPE'].to_i, 'w')
    error_pipe.fcntl(Fcntl::F_SETFD, Fcntl::FD_CLOEXEC)
  end

  raise $! if $! # an exception was already thrown when parsing the formula

  trap("INT", STD_TRAP) # restore default CTRL-C handler

  require 'keg'
  require 'extend/ENV'

  # Force any future invocations of sudo to require the user's password to be
  # re-entered. This is in-case any build script call sudo. Certainly this is
  # can be inconvenient for the user. But we need to be safe.
  system "/usr/bin/sudo", "-k"

  formula = Formulary.factory($0, ARGV.spec)
  Build.new(formula).install
rescue Exception => e
  unless error_pipe.nil?
    e.continuation = nil if ARGV.debug?
    Marshal.dump(e, error_pipe)
    error_pipe.close
    exit! 1
  else
    onoe e
    puts e.backtrace
    exit! 2
  end
end

class Build
  attr_reader :f, :deps, :reqs

  def initialize(f)
    @f = f

    if ARGV.ignore_deps?
      @deps = []
      @reqs = []
    else
      @deps = expand_deps
      @reqs = expand_reqs
    end
  end

  def post_superenv_hacks
    # Only allow Homebrew-approved directories into the PATH, unless
    # a formula opts-in to allowing the user's path.
    if f.env.userpaths? || reqs.any? { |rq| rq.env.userpaths? }
      ENV.userpaths!
    end
  end

  def pre_superenv_hacks
    # Allow a formula to opt-in to the std environment.
    if (f.env.std? || deps.any? { |d| d.name == "scons" }) && ARGV.env != "super"
      ARGV.unshift "--env=std"
    end
  end

  def expand_reqs
    f.recursive_requirements do |dependent, req|
      if (req.optional? || req.recommended?) && dependent.build.without?(req)
        Requirement.prune
      elsif req.build? && dependent != f
        Requirement.prune
      elsif req.satisfied? && req.default_formula? && (dep = req.to_dependency).installed?
        deps << dep
        Requirement.prune
      end
    end
  end

  def expand_deps
    f.recursive_dependencies do |dependent, dep|
      if (dep.optional? || dep.recommended?) && dependent.build.without?(dep)
        Dependency.prune
      elsif dep.build? && dependent != f
        Dependency.prune
      elsif dep.build?
        Dependency.keep_but_prune_recursive_deps
      end
    end
  end

  def install
    keg_only_deps = deps.map(&:to_formula).select(&:keg_only?)

    deps.map(&:to_formula).each do |dep|
      opt = HOMEBREW_PREFIX.join("opt", dep.name)
      fixopt(dep) unless opt.directory?
    end

    pre_superenv_hacks
    ENV.activate_extensions!

    if superenv?
      ENV.keg_only_deps = keg_only_deps.map(&:name)
      ENV.deps = deps.map { |d| d.to_formula.name }
      ENV.x11 = reqs.any? { |rq| rq.kind_of?(X11Dependency) }
      ENV.setup_build_environment(f)
      post_superenv_hacks
      reqs.each(&:modify_build_environment)
      deps.each(&:modify_build_environment)
    else
      ENV.setup_build_environment(f)
      reqs.each(&:modify_build_environment)
      deps.each(&:modify_build_environment)

      keg_only_deps.each do |dep|
        ENV.prepend_path "PATH", dep.opt_bin.to_s
        ENV.prepend_path "PKG_CONFIG_PATH", "#{dep.opt_lib}/pkgconfig"
        ENV.prepend_path "PKG_CONFIG_PATH", "#{dep.opt_share}/pkgconfig"
        ENV.prepend_path "ACLOCAL_PATH", "#{dep.opt_share}/aclocal"
        ENV.prepend_path "CMAKE_PREFIX_PATH", dep.opt_prefix.to_s
        ENV.prepend "LDFLAGS", "-L#{dep.opt_lib}" if dep.opt_lib.directory?
        ENV.prepend "CPPFLAGS", "-I#{dep.opt_include}" if dep.opt_include.directory?
      end
    end

    f.brew do
      if ARGV.flag? '--git'
        system "git", "init"
        system "git", "add", "-A"
      end
      if ARGV.interactive?
        ohai "Entering interactive mode"
        puts "Type `exit' to return and finalize the installation"
        puts "Install to this prefix: #{f.prefix}"

        if ARGV.flag? '--git'
          puts "This directory is now a git repo. Make your changes and then use:"
          puts "  git diff | pbcopy"
          puts "to copy the diff to the clipboard."
        end

        interactive_shell f
      else
        f.prefix.mkpath

        f.resources.each { |r| r.extend(ResourceDebugger) } if ARGV.debug?

        begin
          f.install

          keg = Keg.new(f.prefix)
          # This first test includes executables because we still
          # want to record the stdlib for something that installs no
          # dylibs.
          stdlibs = keg.detect_cxx_stdlibs
          # This currently only tracks a single C++ stdlib per dep,
          # though it's possible for different libs/executables in
          # a given formula to link to different ones.
          stdlib_in_use = CxxStdlib.create(stdlibs.first, ENV.compiler)
          begin
            stdlib_in_use.check_dependencies(f, deps)
          rescue IncompatibleCxxStdlibs => e
            opoo e.message
          end

          # This second check is recorded for checking dependencies,
          # so executable are irrelevant at this point. If a piece
          # of software installs an executable that links against libstdc++
          # and dylibs against libc++, libc++-only dependencies can safely
          # link against it.
          stdlibs = keg.detect_cxx_stdlibs :skip_executables => true

          Tab.create(f, ENV.compiler, stdlibs.first, f.build).write
        rescue Exception => e
          if ARGV.debug?
            debrew e, f
          else
            raise e
          end
        end

        # Find and link metafiles
        f.prefix.install_metafiles Pathname.pwd
      end
    end
  end

  def fixopt f
    path = if f.linked_keg.directory? and f.linked_keg.symlink?
      f.linked_keg.resolved_path
    elsif f.prefix.directory?
      f.prefix
    elsif (kids = f.rack.children).size == 1 and kids.first.directory?
      kids.first
    else
      raise
    end
    Keg.new(path).optlink
  rescue StandardError
    raise "#{f.opt_prefix} not present or broken\nPlease reinstall #{f}. Sorry :("
  end
end
