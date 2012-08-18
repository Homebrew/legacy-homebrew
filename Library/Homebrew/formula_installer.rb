require 'exceptions'
require 'formula'
require 'keg'
require 'tab'
require 'bottles'

class FormulaInstaller
  attr :f
  attr :tab
  attr :show_summary_heading, true
  attr :ignore_deps, true
  attr :install_bottle, true
  attr :show_header, true

  def initialize ff, tab=nil
    @f = ff
    @tab = tab
    @show_header = true
    @ignore_deps = ARGV.ignore_deps? || ARGV.interactive?
    @install_bottle = install_bottle? ff

    check_install_sanity
  end

  def check_install_sanity
    if f.installed?
      keg = Keg.new(f.installed_prefix)
      raise CannotInstallFormulaError, "#{f}-#{keg.version} already installed"
    end

    # Building head-only without --HEAD is an error
    if not ARGV.build_head? and f.stable.nil?
      raise CannotInstallFormulaError, <<-EOS.undent
        #{f} is a head-only formula
        Install with `brew install --HEAD #{f.name}
      EOS
    end

    # Building stable-only with --HEAD is an error
    if ARGV.build_head? and f.head.nil?
      raise CannotInstallFormulaError, "No head is defined for #{f.name}"
    end

    f.recursive_deps.each do |dep|
      if dep.installed? and not dep.keg_only? and not dep.linked_keg.directory?
        raise CannotInstallFormulaError,
              "You must `brew link #{dep}' before #{f} can be installed"
      end
    end unless ignore_deps

  rescue FormulaUnavailableError => e
    # this is sometimes wrong if the dependency chain is more than one deep
    # but can't easily fix this without a rewrite FIXME-brew2
    e.dependent = f.name
    raise
  end

  def install
    # not in initialize so upgrade can unlink the active keg before calling this
    # function but after instantiating this class so that it can avoid having to
    # relink the active keg if possible (because it is slow).
    if f.linked_keg.directory?
      # some other version is already installed *and* linked
      raise CannotInstallFormulaError, <<-EOS.undent
        #{f}-#{f.linked_keg.realpath.basename} already installed
        To install this version, first `brew unlink #{f}'
      EOS
    end

    unless ignore_deps
      needed_deps = []
      needed_reqs = []

      ARGV.filter_for_dependencies do
        needed_deps = f.recursive_deps.reject{ |d| d.installed? }
        needed_reqs = f.recursive_requirements.reject { |r| r.satisfied? }
      end

      unless needed_reqs.empty?
        puts needed_reqs.map { |r| r.message } * "\n"
        fatals = needed_reqs.select { |r| r.fatal? }
        raise UnsatisfiedRequirements.new(f, fatals) unless fatals.empty?
      end

      unless needed_deps.empty?
        needed_deps.each do |dep|
          if dep.explicitly_requested?
            install_dependency dep
          else
            ARGV.filter_for_dependencies do
              # Re-create the formula object so that args like `--HEAD` won't
              # affect properties like the installation prefix. Also need to
              # re-check installed status as the Formula may have changed.
              dep = Formula.factory dep.path
              install_dependency dep unless dep.installed?
            end
          end
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

    opoo "Nothing was installed to #{f.prefix}" unless f.installed?
  end

  def install_dependency dep
    dep_tab = Tab.for_formula(dep)
    outdated_keg = Keg.new(dep.linked_keg.realpath) rescue nil

    fi = FormulaInstaller.new(dep, dep_tab)
    fi.ignore_deps = true
    fi.show_header = false
    oh1 "Installing #{f} dependency: #{dep}"
    outdated_keg.unlink if outdated_keg
    fi.install
    fi.caveats
    fi.finish
  ensure
    # restore previous installation state if build failed
    outdated_keg.link if outdated_keg and not dep.installed? rescue nil
  end

  def caveats
    unless f.caveats.to_s.strip.empty?
      ohai "Caveats", f.caveats
      @show_summary_heading = true
    end

    if f.keg_only?
      ohai 'Caveats', f.keg_only_text
      @show_summary_heading = true
    else
      audit_bin
      audit_sbin
      audit_lib
      check_manpages
      check_infopages
      check_m4
    end

    keg = Keg.new(f.prefix)

    if keg.completion_installed? :bash
      ohai 'Caveats', <<-EOS.undent
        Bash completion has been installed to:
          #{HOMEBREW_PREFIX}/etc/bash_completion.d
        EOS
    end

    if keg.completion_installed? :zsh
      ohai 'Caveats', <<-EOS.undent
        zsh completion has been installed to:
          #{HOMEBREW_PREFIX}/share/zsh/site-functions
        EOS
    end
  end

  def finish
    ohai 'Finishing up' if ARGV.verbose?

    unless f.keg_only?
      link
      check_PATH
    end
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

    args = ARGV.clone
    unless args.include? '--fresh'
      unless tab.nil?
        args.concat tab.used_options
        # FIXME: enforce the download of the non-bottled package
        # in the spawned Ruby process.
        args << '--build-from-source'
      end
      args.uniq! # Just in case some dupes were added
    end

    fork do
      begin
        read.close
        exec '/usr/bin/nice',
             '/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby',
             '-W0',
             '-I', Pathname.new(__FILE__).dirname,
             '-rbuild',
             '--',
             f.path,
             *args.options_only
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

    # This is the installation receipt. The reason this comment is necessary
    # is because some numpty decided to call the class Tab rather than
    # the far more appropriate InstallationReceipt :P
    Tab.for_install(f, args).write

  rescue Exception => e
    ignore_interrupts do
      # any exceptions must leave us with nothing installed
      if f.prefix.directory?
        puts "One sec, just cleaning up..." if e.kind_of? Interrupt
        f.prefix.rmtree
      end
      f.rack.rmdir_if_possible
    end
    raise
  end

  def link
    if f.linked_keg.directory? and f.linked_keg.realpath == f.prefix
      opoo "This keg was marked linked already, continuing anyway"
      # otherwise Keg.link will bail
      f.linked_keg.unlink
    end

    keg = Keg.new(f.prefix)
    keg.link
  rescue Exception => e
    onoe "The linking step did not complete successfully"
    puts "The formula built, but is not symlinked into #{HOMEBREW_PREFIX}"
    puts "You can try again using `brew link #{f.name}'"
    keg.unlink

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
    fetched, downloader = f.fetch
    f.verify_download_integrity fetched
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
      opoo 'A top-level "man" directory was found.'
      puts "Homebrew requires that man pages live under share."
      puts 'This can often be fixed by passing "--mandir=#{man}" to configure.'
      @show_summary_heading = true
    end
  end

  def check_infopages
    # Check for info pages that aren't in share/info
    if (f.prefix+'info').exist?
      opoo 'A top-level "info" directory was found.'
      puts "Homebrew suggests that info pages live under share."
      puts 'This can often be fixed by passing "--infodir=#{info}" to configure.'
      @show_summary_heading = true
    end
  end

  def check_jars
    return unless File.exist? f.lib

    jars = f.lib.children.select{|g| g.to_s =~ /\.jar$/}
    unless jars.empty?
      opoo 'JARs were installed to "lib".'
      puts "Installing JARs to \"lib\" can cause conflicts between packages."
      puts "For Java software, it is typically better for the formula to"
      puts "install to \"libexec\" and then symlink or wrap binaries into \"bin\"."
      puts "See \"activemq\", \"jruby\", etc. for examples."
      puts "The offending files are:"
      puts jars
      @show_summary_heading = true
    end
  end

  def check_non_libraries
    return unless File.exist? f.lib

    valid_extensions = %w(.a .dylib .framework .jnilib .la .o .so
                          .jar .prl .pm)
    non_libraries = f.lib.children.select do |g|
      next if g.directory?
      not valid_extensions.include? g.extname
    end

    unless non_libraries.empty?
      opoo 'Non-libraries were installed to "lib".'
      puts "Installing non-libraries to \"lib\" is bad practice."
      puts "The offending files are:"
      puts non_libraries
      @show_summary_heading = true
    end
  end

  def audit_bin
    return unless File.exist? f.bin

    non_exes = f.bin.children.select {|g| File.directory? g or not File.executable? g}

    unless non_exes.empty?
      opoo 'Non-executables were installed to "bin".'
      puts "Installing non-executables to \"bin\" is bad practice."
      puts "The offending files are:"
      puts non_exes
      @show_summary_heading = true
    end
  end

  def audit_sbin
    return unless File.exist? f.sbin

    non_exes = f.sbin.children.select {|g| File.directory? g or not File.executable? g}

    unless non_exes.empty?
      opoo 'Non-executables were installed to "sbin".'
      puts "Installing non-executables to \"sbin\" is bad practice."
      puts "The offending files are:"
      puts non_exes
      @show_summary_heading = true
    end
  end

  def audit_lib
    check_jars
    check_non_libraries
  end

  def check_m4
    # Newer versions of Xcode don't come with autotools
    return if MacOS::Xcode.version.to_f >= 4.3

    # If the user has added our path to dirlist, don't complain
    return if File.open("/usr/share/aclocal/dirlist") do |dirlist|
      dirlist.grep(%r{^#{HOMEBREW_PREFIX}/share/aclocal$}).length > 0
    end rescue false

    # Check for installed m4 files
    if Dir[f.share+"aclocal/*.m4"].length > 0
      opoo 'm4 macros were installed to "share/aclocal".'
      puts "Homebrew does not append \"#{HOMEBREW_PREFIX}/share/aclocal\""
      puts "to \"/usr/share/aclocal/dirlist\". If an autoconf script you use"
      puts "requires these m4 macros, you'll need to add this path manually."
      @show_summary_heading = true
    end
  end
end


class Formula
  def keg_only_text
    # Add indent into reason so undent won't truncate the beginnings of lines
    reason = self.keg_only_reason.to_s.gsub(/[\n]/, "\n    ")
    return <<-EOS.undent
    This formula is keg-only, so it was not symlinked into #{HOMEBREW_PREFIX}.

    #{reason}

    Generally there are no consequences of this for you.
    If you build your own software and it requires this formula, you'll need
    to add its lib & include paths to your build variables:

        LDFLAGS  -L#{lib}
        CPPFLAGS -I#{include}
    EOS
  end
end
