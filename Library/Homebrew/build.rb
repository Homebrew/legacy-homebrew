#!/usr/bin/ruby

# This script is called by formula_installer as a separate instance.
# Rationale: Formula can use __END__, Formula can change ENV
# Thrown exceptions are propogated back to the parent process over a pipe

ORIGINAL_PATHS = ENV['PATH'].split(':').map{ |p| File.expand_path p }

require 'global'

at_exit do
  # the whole of everything must be run in at_exit because the formula has to
  # be the run script as __END__ must work for *that* formula.

  begin
    raise $! if $! # an exception was already thrown when parsing the formula

    require 'extend/ENV'
    require 'hardware'
    require 'keg'

    ENV.extend(HomebrewEnvExtension)
    ENV.setup_build_environment
    # we must do this or tools like pkg-config won't get found by configure scripts etc.
    ENV.prepend 'PATH', "#{HOMEBREW_PREFIX}/bin", ':' unless ORIGINAL_PATHS.include? "#{HOMEBREW_PREFIX}/bin"
    # this is a safety measure for Xcode 4.3 which started not installing
    # dev tools into /usr/bin as a default
    ENV.prepend 'PATH', MacOS.dev_tools_path, ':' unless ORIGINAL_PATHS.include? MacOS.dev_tools_path

    # Force any future invocations of sudo to require the user's password to be
    # re-entered. This is in-case any build script call sudo. Certainly this is
    # can be inconvenient for the user. But we need to be safe.
    system "/usr/bin/sudo -k"

    install(Formula.factory($0))
  rescue Exception => e
    if ENV['HOMEBREW_ERROR_PIPE']
      pipe = IO.new(ENV['HOMEBREW_ERROR_PIPE'].to_i, 'w')
      Marshal.dump(e, pipe)
      pipe.close
      exit! 1
    else
      onoe e
      puts e.backtrace
      exit! 2
    end
  end
end

def install f
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
    if ARGV.flag? '--interactive'
      ohai "Entering interactive mode"
      puts "Type `exit' to return and finalize the installation"
      puts "Install to this prefix: #{f.prefix}"

      if ARGV.flag? '--git'
        system "git init"
        system "git add -A"
        puts "This directory is now a git repo. Make your changes and then use:"
        puts "  git diff | pbcopy"
        puts "to copy the diff to the clipboard."
      end

      interactive_shell f
      nil
    elsif ARGV.include? '--help'
      system './configure --help'
      exit $?
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
rescue Exception
  if f.prefix.directory?
    f.prefix.rmtree
    f.rack.rmdir_if_possible
  end
  raise
end
