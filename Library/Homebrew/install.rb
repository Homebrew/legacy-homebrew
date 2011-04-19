#!/usr/bin/ruby
require 'global'

def text_for_keg_only_formula f
  <<-EOS
This formula is keg-only, so it was not symlinked into #{HOMEBREW_PREFIX}.

#{f.keg_only?}

Generally there are no consequences of this for you.
If you build your own software and it requires this formula, you'll need
to add its lib & include paths to your build variables:

  LDFLAGS: -L#{f.lib}
  CPPFLAGS: -I#{f.include}
  EOS
end

# I like this little at all, but see no alternative seeing as the formula
# rb file has to be the running script to allow it to use __END__ and DATA
at_exit do
  begin
    raise $! if $! # an exception was already thrown when parsing the formula

    require 'extend/ENV'
    require 'fileutils'
    require 'hardware'
    require 'keg'
    require 'compatibility'

    ENV.extend(HomebrewEnvExtension)
    ENV.setup_build_environment

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

ORIGINAL_PATHS = ENV['PATH'].split(':').map{ |p| File.expand_path p }
HOMEBREW_BIN = (HOMEBREW_PREFIX+'bin').to_s

def install f
  show_summary_heading = false

  # we must do this or tools like pkg-config won't get found by configure scripts etc.
  ENV.prepend 'PATH', HOMEBREW_BIN, ':' unless ORIGINAL_PATHS.include? HOMEBREW_BIN

  f.deps.uniq.each do |dep|
    dep = Formula.factory dep
    if dep.keg_only?
      ENV.prepend 'LDFLAGS', "-L#{dep.lib}"
      ENV.prepend 'CPPFLAGS', "-I#{dep.include}"
      ENV.prepend 'PATH', "#{dep.bin}", ':'
      ENV.prepend 'PKG_CONFIG_PATH', dep.lib+'pkgconfig', ':'
    end
  end

  build_time = nil
  begin
    f.brew do
      if ARGV.flag? '--interactive'
        ohai "Entering interactive mode"
        puts "Type `exit' to return and finalize the installation"
        puts "Install to this prefix: #{f.prefix}"

        if ARGV.flag? '--git'
          system "git init"
          system "git add -A"
          puts "This folder is now a git repo. Make your changes and then use:"
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
        beginning=Time.now
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
        build_time = Time.now-beginning
      end
    end
  rescue Exception
    if f.prefix.directory?
      f.prefix.rmtree
      f.prefix.parent.rmdir_if_possible
    end
    raise
  end

  if f.caveats
    ohai "Caveats", f.caveats
    show_summary_heading = true
  end

  ohai 'Finishing up' if ARGV.verbose?

  keg = Keg.new f.prefix

  begin
    keg.fix_install_names
  rescue Exception => e
    onoe "Failed to fix install names"
    puts "The formula built, but you may encounter issues using it or linking other"
    puts "formula against it."
    ohai e, e.backtrace if ARGV.debug?
    show_summary_heading = true
  end

  begin
    require 'cleaner'
    Cleaner.new f
  rescue Exception => e
    opoo "The cleaning step did not complete successfully"
    puts "Still, the installation was successful, so we will link it into your prefix"
    ohai e, e.backtrace if ARGV.debug?
    show_summary_heading = true
  end

  raise "Nothing was installed to #{f.prefix}" unless f.installed?

  if f.keg_only?
    ohai 'Caveats', text_for_keg_only_formula(f)
    show_summary_heading = true
  else
    # warn the user if stuff was installed outside of their PATH
    [f.bin, f.sbin].each do |bin|
      if bin.directory?
        bin = File.expand_path bin
        unless ORIGINAL_PATHS.include? HOMEBREW_BIN
          opoo "#{HOMEBREW_BIN} is not in your PATH"
          puts "You can amend this by altering your ~/.bashrc file"
          show_summary_heading = true
        end
      end
    end

    # Check for man pages that aren't in share/man
    if (f.prefix+'man').exist?
      opoo 'A top-level "man" folder was found.'
      puts "Homebrew requires that man pages live under share."
      puts 'This can often be fixed by passing "--mandir=#{man}" to configure.'
    end

    # Check for info pages that aren't in share/info
    if (f.prefix+'info').exist?
      opoo 'A top-level "info" folder was found.'
      puts "Homebrew suggests that info pages live under share."
      puts 'This can often be fixed by passing "--infodir=#{info}" to configure.'
    end

    # Check for Jars in lib
    if File.exist?(f.lib)
      unless f.lib.children.select{|g| g.to_s =~ /\.jar$/}.empty?
        opoo 'JARs were installed to "lib".'
        puts "Installing JARs to \"lib\" can cause conflicts between packages."
        puts "For Java software, it is typically better for the formula to"
        puts "install to \"libexec\" and then symlink or wrap binaries into \"bin\"."
        puts "See \"activemq\", \"jruby\", etc. for examples."
      end
    end

    # Check for m4 files
    if Dir[f.share+"aclocal/*.m4"].length > 0
      opoo 'm4 macros were installed to "share/aclocal".'
      puts "Homebrew does not append \"#{HOMEBREW_PREFIX}/share/aclocal\""
      puts "to \"/usr/share/aclocal/dirlist\". If an autoconf script you use"
      puts "requires these m4 macros, you'll need to add this path manually."
    end

    # link from Cellar to Prefix
    begin
      keg.link
    rescue Exception => e
      onoe "The linking step did not complete successfully"
      puts "The formula built, but is not symlinked into #{HOMEBREW_PREFIX}"
      puts "You can try again using `brew link #{f.name}'"
      if ARGV.debug?
        ohai e, e.backtrace
      else
        onoe e
      end
      show_summary_heading = true
    end
  end

  ohai "Summary" if ARGV.verbose? or show_summary_heading
  print "#{f.prefix}: #{f.prefix.abv}"
  print ", built in #{pretty_duration build_time}" if build_time
  puts
end
