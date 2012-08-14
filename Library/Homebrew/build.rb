#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby

# This script is called by formula_installer as a separate instance.
# Rationale: Formula can use __END__, Formula can change ENV
# Thrown exceptions are propogated back to the parent process over a pipe

require 'global'

at_exit do
  # the whole of everything must be run in at_exit because the formula has to
  # be the run script as __END__ must work for *that* formula.

  error_pipe = nil

  begin
    raise $! if $! # an exception was already thrown when parsing the formula

    require 'extend/ENV'
    require 'hardware'
    require 'keg'

    ENV.extend(HomebrewEnvExtension)
    ENV.setup_build_environment
    # we must do this or tools like pkg-config won't get found by configure scripts etc.
    ENV.prepend 'PATH', "#{HOMEBREW_PREFIX}/bin", ':' unless ORIGINAL_PATHS.include? HOMEBREW_PREFIX/'bin'

    # Force any future invocations of sudo to require the user's password to be
    # re-entered. This is in-case any build script call sudo. Certainly this is
    # can be inconvenient for the user. But we need to be safe.
    system "/usr/bin/sudo -k"

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
end

def install f
  f.requirements.each { |dep| dep.modify_build_environment }

  f.recursive_deps.uniq.each do |dep|
    dep = Formula.factory dep
    if dep.keg_only?
      ENV.prepend 'LDFLAGS', "-L#{dep.lib}"
      ENV.prepend 'CPPFLAGS', "-I#{dep.include}"
      ENV.prepend 'PATH', "#{dep.bin}", ':'

      pcdir = dep.lib/'pkgconfig'
      ENV.prepend 'PKG_CONFIG_PATH', pcdir, ':' if pcdir.directory?

      acdir = dep.share/'aclocal'
      ENV.prepend 'ACLOCAL_PATH', acdir, ':' if acdir.directory?
    end
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
      nil
    else
      f.prefix.mkpath
      f.install
      FORMULA_META_FILES.each do |filename|
        next if File.directory? filename
        target_file = filename
        target_file = "#{filename}.txt" if File.exists? "#{filename}.txt"
        # Some software symlinks these files (see help2man.rb)
        target_file = Pathname.new(target_file).resolved_path
        f.prefix.install target_file => filename rescue nil
        (f.prefix+file).chmod 0644 rescue nil
      end
    end
  end
end
