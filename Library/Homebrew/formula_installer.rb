require 'exceptions'
require 'formula'
require 'keg'
require 'set'

class FormulaInstaller
  attr :f
  attr :show_summary_heading, true
  attr :ignore_deps, true
  attr :install_bottle, true
  attr :show_header, true

  def initialize ff
    @f = ff
    @show_header = true
    @ignore_deps = ARGV.include? '--ignore-dependencies' || ARGV.interactive?
    @install_bottle = !ff.bottle.nil? && !ARGV.build_from_source? &&
                      Pathname.new(ff.bottle).version == ff.version
  end

  def install
    raise FormulaAlreadyInstalledError, f if f.installed? and not ARGV.force?

    unless ignore_deps
      f.check_external_deps

      needed_deps = f.recursive_deps.reject{ |d| d.installed? }
      unless needed_deps.empty?
        needed_deps.each do |dep|
          fi = FormulaInstaller.new(dep)
          fi.ignore_deps = true
          fi.show_header = false
          oh1 "Installing #{f} dependency: #{dep}"
          fi.install
          fi.caveats
          fi.finish
        end

        # now show header as all the deps stuff has clouded the original issue
        show_header = true
      end
    end

    oh1 "Installing #{f}" if show_header

    @@attempted ||= Set.new
    raise FormulaInstallationAlreadyAttemptedError, f if @@attempted.include? f
    @@attempted << f

    if install_bottle
      pour
    else
      build
      clean
    end

    raise "Nothing was installed to #{f.prefix}" unless f.installed?
  end

  def caveats
    if f.caveats
      ohai "Caveats", f.caveats
      @show_summary_heading = true
    end
    if f.keg_only?
      ohai 'Caveats', f.keg_only_text
      @show_summary_heading = true
    else
      check_PATH
      check_manpages
      check_infopages
      check_jars
      check_m4
    end
  end

  def finish
    ohai 'Finishing up' if ARGV.verbose?

    link unless f.keg_only?
    fix_install_names

    ohai "Summary" if ARGV.verbose? or show_summary_heading
    print "#{f.prefix}: #{f.prefix.abv}"
    print ", built in #{pretty_duration build_time}" if build_time
    puts
  end

  def build_time
    @build_time ||= Time.now - @start_time unless install_bottle or ARGV.interactive? or @start_time.nil?
  end

  def build
    @start_time = Time.now

    # 1. formulae can modify ENV, so we must ensure that each
    #    installation has a pristine ENV when it starts, forking now is
    #    the easiest way to do this
    # 2. formulae have access to __END__ the only way to allow this is
    #    to make the formula script the executed script
    read, write = IO.pipe
    # I'm guessing this is not a good way to do this, but I'm no UNIX guru
    ENV['HOMEBREW_ERROR_PIPE'] = write.to_i.to_s

    fork do
      begin
        read.close
        exec '/usr/bin/nice',
             '/usr/bin/ruby',
             '-I', Pathname.new(__FILE__).dirname,
             '-rbuild',
             '--',
             f.path,
             *ARGV.options_only
      rescue Exception => e
        Marshal.dump(e, write)
        write.close
        exit! 1
      end
    end

    ignore_interrupts do # the fork will receive the interrupt and marshall it back
      write.close
      Process.wait
      data = read.read
      raise Marshal.load(data) unless data.nil? or data.empty?
      raise "Suspicious installation failure" unless $?.success?
    end
  end

  def link
    Keg.new(f.prefix).link
  rescue Exception => e
    onoe "The linking step did not complete successfully"
    puts "The formula built, but is not symlinked into #{HOMEBREW_PREFIX}"
    puts "You can try again using `brew link #{f.name}'"
    ohai e, e.backtrace if ARGV.debug?
    @show_summary_heading = true
  end

  def fix_install_names
    Keg.new(f.prefix).fix_install_names
  rescue Exception => e
    onoe "Failed to fix install names"
    puts "The formula built, but you may encounter issues using it or linking other"
    puts "formula against it."
    ohai e, e.backtrace if ARGV.debug?
    @show_summary_heading = true
  end

  def clean
    require 'cleaner'
    Cleaner.new f
  rescue Exception => e
    opoo "The cleaning step did not complete successfully"
    puts "Still, the installation was successful, so we will link it into your prefix"
    ohai e, e.backtrace if ARGV.debug?
    @show_summary_heading = true
  end

  def pour
    HOMEBREW_CACHE.mkpath
    downloader = CurlBottleDownloadStrategy.new f.bottle, f.name, f.version, nil
    downloader.fetch
    f.verify_download_integrity downloader.tarball_path, f.bottle_sha1, "SHA1"
    HOMEBREW_CELLAR.cd do
      downloader.stage
    end
  end

  ## checks

  def paths
    @paths ||= ENV['PATH'].split(':').map{ |p| File.expand_path p }
  end

  def check_PATH
    # warn the user if stuff was installed outside of their PATH
    [f.bin, f.sbin].each do |bin|
      if bin.directory? and bin.children.length > 0
        bin = (HOMEBREW_PREFIX/bin.basename).realpath.to_s
        unless paths.include? bin
          opoo "#{bin} is not in your PATH"
          puts "You can amend this by altering your ~/.bashrc file"
          @show_summary_heading = true
        end
      end
    end
  end

  def check_manpages
    # Check for man pages that aren't in share/man
    if (f.prefix+'man').exist?
      opoo 'A top-level "man" folder was found.'
      puts "Homebrew requires that man pages live under share."
      puts 'This can often be fixed by passing "--mandir=#{man}" to configure.'
      @show_summary_heading = true
    end
  end

  def check_infopages
    # Check for info pages that aren't in share/info
    if (f.prefix+'info').exist?
      opoo 'A top-level "info" folder was found.'
      puts "Homebrew suggests that info pages live under share."
      puts 'This can often be fixed by passing "--infodir=#{info}" to configure.'
      @show_summary_heading = true
    end
  end

  def check_jars
    # Check for Jars in lib
    if File.exist?(f.lib)
      unless f.lib.children.select{|g| g.to_s =~ /\.jar$/}.empty?
        opoo 'JARs were installed to "lib".'
        puts "Installing JARs to \"lib\" can cause conflicts between packages."
        puts "For Java software, it is typically better for the formula to"
        puts "install to \"libexec\" and then symlink or wrap binaries into \"bin\"."
        puts "See \"activemq\", \"jruby\", etc. for examples."
        @show_summary_heading = true
      end
    end
  end

  def check_m4
    # Check for m4 files
    if Dir[f.share+"aclocal/*.m4"].length > 0
      opoo 'm4 macros were installed to "share/aclocal".'
      puts "Homebrew does not append \"#{HOMEBREW_PREFIX}/share/aclocal\""
      puts "to \"/usr/share/aclocal/dirlist\". If an autoconf script you use"
      puts "requires these m4 macros, you'll need to add this path manually."
      @show_summary_heading = true
    end
  end
end


def external_dep_check dep, type
  case type
    when :python then %W{/usr/bin/env python -c import\ #{dep}}
    when :jruby then %W{/usr/bin/env jruby -rubygems -e require\ '#{dep}'}
    when :ruby then %W{/usr/bin/env ruby -rubygems -e require\ '#{dep}'}
    when :perl then %W{/usr/bin/env perl -e use\ #{dep}}
  end
end


class Formula
  def keg_only_text; <<-EOS.undent
    This formula is keg-only, so it was not symlinked into #{HOMEBREW_PREFIX}.

    #{self.keg_only?}

    Generally there are no consequences of this for you.
    If you build your own software and it requires this formula, you'll need
    to add its lib & include paths to your build variables:

        LDFLAGS  -L#{lib}
        CPPFLAGS -I#{include}
    EOS
  end

  def check_external_deps
    [:ruby, :python, :perl, :jruby].each do |type|
      self.external_deps[type].each do |dep|
        unless quiet_system(*external_dep_check(dep, type))
          raise UnsatisfiedExternalDependencyError.new(dep, type)
        end
      end if self.external_deps[type]
    end
  end
end
