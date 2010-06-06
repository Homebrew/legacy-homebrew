#!/usr/bin/ruby
require 'global'

def text_for_keg_only_formula f
  if f.keg_only? == :provided_by_osx
    rationale = "This is because the formula is already provided by OS X."
  elsif f.keg_only?.kind_of? String
    rationale = "The formula provides the following rationale:\n\n#{f.keg_only?.chomp}"
  else
    rationale = "The formula didn't provide any rationale for this."
  end
  <<-EOS
#{f.name} is keg-only. This means it is not symlinked into Homebrew's
prefix. #{rationale}

Generally there are no consequences of this for you, however if you build your
own software and it requires this formula, you may want to run this command to
link it into the Homebrew prefix:

    brew link #{f.name}
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
    require 'brew.h.rb'

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

def install f
  show_summary_heading = false

  f.deps.each do |dep|
    dep = Formula.factory dep
    if dep.keg_only?
      ENV.prepend 'LDFLAGS', "-L#{dep.lib}"
      ENV.prepend 'CPPFLAGS', "-I#{dep.include}"
      ENV.prepend 'PATH', "#{dep.bin}", ':'
      ENV.prepend 'PKG_CONFIG_PATH', dep.lib+'pkgconfig', ':'
    end
  end

  if ARGV.verbose?
    ohai "Build Environment"
    dump_build_env ENV
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

        interactive_shell
        nil
      elsif ARGV.include? '--help'
        system './configure --help'
        exit $?
      else
        f.prefix.mkpath
        beginning=Time.now
        f.install
        FORMULA_META_FILES.each do |file|
          FileUtils.mv "#{file}.txt", file rescue nil
          f.prefix.install file rescue nil
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

  begin
    clean f
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
    paths = ENV['PATH'].split(':').collect{|p| File.expand_path p}
    [f.bin, f.sbin].each do |bin|
      if bin.directory?
        rootbin = (HOMEBREW_PREFIX+bin.basename).to_s
        bin = File.expand_path bin
        unless paths.include? rootbin
          opoo "#{rootbin} is not in your PATH"
          puts "You can amend this by altering your ~/.bashrc file"
          show_summary_heading = true
        end
      end
    end

    # Check for possibly misplaced folders
    if (f.prefix+'man').exist?
      opoo 'A top-level "man" folder was found.'
      puts "Homebrew requires that man pages live under share."
      puts 'This can often be fixed by passing "--mandir=#{man}" to configure,'
      puts 'or by installing manually with "man1.install \'mymanpage.1\'".'
    end

    # link from Cellar to Prefix
    begin
      Keg.new(f.prefix).link
    rescue Exception => e
      onoe "The linking step did not complete successfully"
      puts "The package built, but is not symlinked into #{HOMEBREW_PREFIX}"
      puts "You can try again using `brew link #{f.name}'"
      ohai e, e.backtrace if ARGV.debug?
      show_summary_heading = true
    end
  end

  ohai "Summary" if ARGV.verbose? or show_summary_heading
  print "#{f.prefix}: #{f.prefix.abv}"
  print ", built in #{pretty_duration build_time}" if build_time
  puts
end
