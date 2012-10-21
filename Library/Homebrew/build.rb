#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby -W0

# This script is called by formula_installer as a separate instance.
# Rationale: Formula can use __END__, Formula can change ENV
# Thrown exceptions are propogated back to the parent process over a pipe

STD_TRAP = trap("INT") { exit! 130 } # no backtrace thanks

at_exit do
  # the whole of everything must be run in at_exit because the formula has to
  # be the run script as __END__ must work for *that* formula.
  main
end

require 'global'

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

  require 'hardware'
  require 'keg'

  # Force any future invocations of sudo to require the user's password to be
  # re-entered. This is in-case any build script call sudo. Certainly this is
  # can be inconvenient for the user. But we need to be safe.
  system "/usr/bin/sudo -k"

  install(Formula.factory($0))
rescue Exception => e
  unless error_pipe.nil?
    Marshal.dump(e, error_pipe)
    error_pipe.close
    exit! 1
  else
    onoe e
    puts e.backtrace
    exit! 2
  end
end

def post_superenv_hacks f
  # Only allow Homebrew-approved directories into the PATH, unless
  # a formula opts-in to allowing the user's path.
  if f.env.userpaths?
    paths = ORIGINAL_PATHS.map{|pn| pn.realpath.to_s rescue nil } - %w{/usr/X11/bin /opt/X11/bin}
    ENV['PATH'] = "#{ENV['PATH']}:#{paths.join(':')}"
  end
end

def pre_superenv_hacks f
  # Allow a formula to opt-in to the std environment.
  ARGV.unshift '--env=std' if (f.env.std? or
    f.recursive_deps.detect{|d| d.name == 'scons' }) and
    not ARGV.include? '--env=super'
end

def install f
  deps = f.recursive_deps
  keg_only_deps = deps.select{|dep| dep.keg_only? }

  pre_superenv_hacks(f)
  require 'superenv'

  unless superenv?
    ENV.setup_build_environment
    # Requirements are processed first so that adjustments made to ENV
    # for keg-only deps take precdence.
    f.recursive_requirements.each { |rq| rq.modify_build_environment }
  end

  deps.each do |dep|
    opt = HOMEBREW_PREFIX/:opt/dep
    fixopt(dep) unless opt.directory?
    if not superenv? and dep.keg_only?
      ENV.prepend_path 'PATH', "#{opt}/bin"
      ENV.prepend_path 'PKG_CONFIG_PATH', "#{opt}/lib/pkgconfig"
      ENV.prepend_path 'PKG_CONFIG_PATH', "#{opt}/share/pkgconfig"
      ENV.prepend_path 'ACLOCAL_PATH', "#{opt}/share/aclocal"
      ENV.prepend_path 'CMAKE_PREFIX_PATH', opt
      ENV.prepend 'LDFLAGS', "-L#{opt}/lib" if (opt/:lib).directory?
      ENV.prepend 'CPPFLAGS', "-I#{opt}/include" if (opt/:include).directory?
    end
  end

  if superenv?
    ENV.deps = keg_only_deps.map(&:to_s)
    ENV.all_deps = f.recursive_deps.map(&:to_s)
    ENV.x11 = f.recursive_requirements.detect{|rq| rq.class == X11Dependency }
    ENV.setup_build_environment
    f.recursive_requirements.each { |rq| rq.modify_build_environment }
    post_superenv_hacks(f)
  end

  if f.fails_with? ENV.compiler
    cs = CompilerSelector.new f
    cs.select_compiler
    cs.advise
  end

  f.brew do
    if ARGV.flag? '--git'
      system "git init"
      system "git add -A"
    end
    if ARGV.flag? '--interactive'
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
      f.install

      # Find and link metafiles
      FORMULA_META_FILES.each do |filename|
        next if File.directory? filename
        target_file = filename
        target_file = "#{filename}.txt" if File.exists? "#{filename}.txt"
        # Some software symlinks these files (see help2man.rb)
        target_file = Pathname.new(target_file).resolved_path
        f.prefix.install target_file => filename rescue nil
        (f.prefix/filename).chmod 0644 rescue nil
      end
    end
  end
end

def fixopt f
  path = if f.linked_keg.directory? and f.linked_keg.symlink?
    f.linked_keg.realpath
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
