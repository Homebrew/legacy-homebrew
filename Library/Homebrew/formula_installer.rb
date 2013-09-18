# encoding: UTF-8

require 'cxxstdlib'
require 'exceptions'
require 'formula'
require 'keg'
require 'tab'
require 'bottles'
require 'caveats'
require 'cleaner'
require 'formula_cellar_checks'

class FormulaInstaller
  include FormulaCellarChecks

  attr_reader :f
  attr_accessor :tab, :options, :ignore_deps
  attr_accessor :show_summary_heading, :show_header

  def initialize ff
    @f = ff
    @show_header = false
    @ignore_deps = ARGV.ignore_deps? || ARGV.interactive?
    @options = Options.new
    @tab = Tab.dummy_tab(ff)

    @@attempted ||= Set.new

    lock
    check_install_sanity
  end

  def pour_bottle? warn=false
    tab.used_options.empty? && options.empty? && install_bottle?(f, warn)
  end

  def check_install_sanity
    raise FormulaInstallationAlreadyAttemptedError, f if @@attempted.include? f

    if f.installed?
      msg = "#{f}-#{f.installed_version} already installed"
      msg << ", it's just not linked" unless f.linked_keg.symlink? or f.keg_only?
      raise FormulaAlreadyInstalledError, msg
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

    unless ignore_deps
      unlinked_deps = f.recursive_dependencies.map(&:to_formula).select do |dep|
        dep.installed? and not dep.keg_only? and not dep.linked_keg.directory?
      end
      raise CannotInstallFormulaError,
        "You must `brew link #{unlinked_deps*' '}' before #{f} can be installed" unless unlinked_deps.empty?
    end

  rescue FormulaUnavailableError => e
    # this is sometimes wrong if the dependency chain is more than one deep
    # but can't easily fix this without a rewrite FIXME-brew2
    e.dependent = f.name
    raise
  end

  def git_etc_preinstall
    return unless quiet_system 'git', '--version'

    etc = HOMEBREW_PREFIX+'etc'
    etc.cd do
      quiet_system 'git', 'init' unless (etc+'.git').directory?
      quiet_system 'git', 'checkout', '-B', "#{f.name}-last"
      system 'git', 'add', '--all', '.'
      system 'git', 'commit', '-m', "#{f.name}-#{f.version}: preinstall"
    end
  end

  def git_etc_postinstall
    return unless quiet_system 'git', '--version'

    etc = HOMEBREW_PREFIX+'etc'
    keg_etc_files = Dir[f.etc+'*']
    last_branch = "#{f.name}-last"
    default_branch = "#{f.name}-default"
    merged = false
    etc.cd do
      FileUtils.cp_r keg_etc_files, etc

      system 'git', 'add', '--all', '.'
      if quiet_system 'git', 'diff', '--exit-code', default_branch
        quiet_system 'git', 'reset', '--hard'
      else
        if quiet_system 'git', 'rev-parse', 'master'
          quiet_system 'git', 'checkout', '-f', 'master'
          FileUtils.cp_r keg_etc_files, etc
          quiet_system 'git', 'add', '--all', '.'
        else
          quiet_system 'git', 'checkout', '-b' 'master'
        end
        system 'git', 'commit', '-m', "#{f.name}-#{f.version}: default"
        quiet_system 'git', 'branch', '-f', default_branch

        merged = true unless quiet_system 'git' 'merge-base', '--is-ancestor',
                                          last_branch, 'master'
        system 'git', 'merge', '--no-ff', '--no-edit',
               '-X', 'theirs', last_branch
      end

      if merged
        ohai "Configuration Files"
        puts "Your configuration files for #{f.name} in etc were merged:"
        puts "To reverse this merge: git reset --hard #{last_branch}"
        puts "To restore defaults:   git reset --hard #{default_branch}"
      end
    end
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

    check_conflicts

    unless ignore_deps
      perform_readline_hack
      check_requirements
      install_dependencies
    end

    if ARGV.build_bottle? && (arch = ARGV.bottle_arch) && !Hardware::CPU.optimization_flags.include?(arch)
      raise "Unrecognized architecture for --bottle-arch: #{arch}"
    end

    if pour_bottle?
      # TODO We currently only support building with libstdc++ as
      # the default case, and all Apple libstdc++s are compatible, so
      # this default is sensible.
      # In the future we need to actually provide a way to read this from
      # the bottle, or update the default should that change
      # at some other point.
      stdlib_in_use = CxxStdlib.new(:libstdcxx, :clang)
      stdlib_in_use.check_dependencies(f, f.deps)
    end

    oh1 "Installing #{Tty.green}#{f}#{Tty.reset}" if show_header

    @@attempted << f

    git_etc_preinstall if HOMEBREW_GIT_ETC

    @poured_bottle = false

    begin
      if pour_bottle? true
        pour
        @poured_bottle = true
        tab = Tab.for_keg f.prefix
        tab.poured_from_bottle = true
        tab.tabfile.delete rescue nil
        tab.write
      end
    rescue
      raise if ARGV.homebrew_developer?
      opoo "Bottle installation failed: building from source."
    end

    unless @poured_bottle
      build
      clean
    end

    begin
      f.post_install
    rescue
      opoo "#{f.name} post_install failed. Rerun with `brew postinstall #{f.name}`."
    end

    git_etc_postinstall if HOMEBREW_GIT_ETC

    opoo "Nothing was installed to #{f.prefix}" unless f.installed?
  end

  # HACK: If readline is present in the dependency tree, it will clash
  # with the stdlib's Readline module when the debugger is loaded
  def perform_readline_hack
    if f.recursive_dependencies.any? { |d| d.name == "readline" } && ARGV.debug?
      ENV['HOMEBREW_NO_READLINE'] = '1'
    end
  end

  def check_conflicts
    return if ARGV.force?

    conflicts = f.conflicts.reject do |c|
      keg = Formula.factory(c.name).prefix
      not keg.directory? && Keg.new(keg).linked?
    end

    raise FormulaConflictError.new(f, conflicts) unless conflicts.empty?
  end

  def check_requirements
    unsatisfied = ARGV.filter_for_dependencies do
      f.recursive_requirements do |dependent, req|
        if (req.optional? || req.recommended?) && dependent.build.without?(req.name)
          Requirement.prune
        elsif req.build? && install_bottle?(dependent)
          Requirement.prune
        elsif req.satisfied?
          Requirement.prune
        elsif req.default_formula?
          dependent.deps << req.to_dependency
          Requirement.prune
        else
          puts "#{dependent}: #{req.message}"
        end
      end
    end

    fatals = unsatisfied.select(&:fatal?)
    raise UnsatisfiedRequirements.new(f, fatals) unless fatals.empty?
  end

  # Dependencies of f that were also explicitly requested on the command line.
  # These honor options like --HEAD and --devel.
  def requested_deps
    f.recursive_dependencies.select { |dep| dep.requested? && !dep.installed? }
  end

  # All dependencies that we must install before installing f.
  # These do not honor flags like --HEAD and --devel.
  def necessary_deps
    # FIXME: can't check this inside the block for the top-level dependent
    # because it depends on the contents of ARGV.
    pour_bottle = pour_bottle?

    ARGV.filter_for_dependencies do
      f.recursive_dependencies do |dependent, dep|
        dep.universal! if f.build.universal? && !dep.build?

        if (dep.optional? || dep.recommended?) && dependent.build.without?(dep.name)
          Dependency.prune
        elsif dep.build? && dependent == f && pour_bottle
          Dependency.prune
        elsif dep.build? && dependent != f && install_bottle?(dependent)
          Dependency.prune
        elsif dep.satisfied?
          Dependency.skip
        elsif dep.installed?
          raise UnsatisfiedDependencyError.new(f, dep)
        end
      end
    end
  end

  # Combine requested_deps and necessary deps.
  def filter_deps
    deps = Set.new.merge(requested_deps).merge(necessary_deps)
    f.recursive_dependencies.select { |d| deps.include? d }
  end

  def effective_deps
    @effective_deps ||= filter_deps
  end

  def install_dependencies
    oh1 "Installing dependencies for #{f}: #{Tty.green}#{effective_deps.join(", ")}#{Tty.reset}" if not effective_deps.empty?
    effective_deps.each do |dep|
      if dep.requested?
       install_dependency(dep)
      else
        ARGV.filter_for_dependencies { install_dependency(dep) }
      end
    end
    @show_header = true unless effective_deps.empty?
  end

  def install_dependency dep
    dep_tab = Tab.for_formula(dep.to_formula)
    dep_options = dep.options
    dep = dep.to_formula

    outdated_keg = Keg.new(dep.linked_keg.realpath) rescue nil

    fi = FormulaInstaller.new(dep)
    fi.tab = dep_tab
    fi.options = dep_options
    fi.ignore_deps = true
    fi.show_header = false
    oh1 "Installing #{f} dependency: #{Tty.green}#{dep}#{Tty.reset}"
    outdated_keg.unlink if outdated_keg
    fi.install
    fi.caveats
    fi.finish
  ensure
    # restore previous installation state if build failed
    outdated_keg.link if outdated_keg and not dep.installed? rescue nil
  end

  def caveats
    if ARGV.homebrew_developer? and not f.keg_only?
      audit_bin
      audit_sbin
      audit_lib
      audit_man
      audit_info
    end

    c = Caveats.new(f)

    unless c.empty?
      @show_summary_heading = true
      ohai 'Caveats', c.caveats
    end
  end

  def finish
    ohai 'Finishing up' if ARGV.verbose?

    install_plist

    if f.keg_only?
      begin
        Keg.new(f.prefix).optlink
      rescue Exception
        onoe "Failed to create: #{f.opt_prefix}"
        puts "Things that depend on #{f} will probably not build."
      end
    else
      link
    end

    fix_install_names

    ohai "Summary" if ARGV.verbose? or show_summary_heading
    unless ENV['HOMEBREW_NO_EMOJI']
      print "\xf0\x9f\x8d\xba  " if MacOS.version >= :lion
    end
    print "#{f.prefix}: #{f.prefix.abv}"
    print ", built in #{pretty_duration build_time}" if build_time
    puts
  ensure
    unlock if hold_locks?
  end

  def build_time
    @build_time ||= Time.now - @start_time unless pour_bottle? or ARGV.interactive? or @start_time.nil?
  end

  def build_argv
    @build_argv ||= begin
      opts = Options.coerce(ARGV.options_only)
      unless opts.include? '--fresh'
        opts.concat(options) # from a dependent formula
        opts.concat(tab.used_options) # from a previous install
      end
      opts << Option.new("--build-from-source") # don't download bottle
    end
  end

  def build
    FileUtils.rm Dir["#{HOMEBREW_LOGS}/#{f}/*"]

    @start_time = Time.now

    # 1. formulae can modify ENV, so we must ensure that each
    #    installation has a pristine ENV when it starts, forking now is
    #    the easiest way to do this
    # 2. formulae have access to __END__ the only way to allow this is
    #    to make the formula script the executed script
    read, write = IO.pipe
    # I'm guessing this is not a good way to do this, but I'm no UNIX guru
    ENV['HOMEBREW_ERROR_PIPE'] = write.to_i.to_s

    args = %W[
      nice #{RUBY_PATH}
      -W0
      -I #{File.dirname(__FILE__)}
      -rbuild
      --
      #{f.path}
    ].concat(build_argv)

    # Ruby 2.0+ sets close-on-exec on all file descriptors except for
    # 0, 1, and 2 by default, so we have to specify that we want the pipe
    # to remain open in the child process.
    args << { write => write } if RUBY_VERSION >= "2.0"

    fork do
      begin
        read.close
        exec(*args)
      rescue Exception => e
        Marshal.dump(e, write)
        write.close
        exit! 1
      end
    end

    ignore_interrupts(:quietly) do # the fork will receive the interrupt and marshall it back
      write.close
      Process.wait
      data = read.read
      read.close
      raise Marshal.load(data) unless data.nil? or data.empty?
      raise Interrupt if $?.exitstatus == 130
      raise "Suspicious installation failure" unless $?.success?
    end

    raise "Empty installation" if Dir["#{f.prefix}/*"].empty?

  rescue Exception
    ignore_interrupts do
      # any exceptions must leave us with nothing installed
      f.prefix.rmtree if f.prefix.directory?
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

    begin
      keg.link
    rescue Exception => e
      onoe "The `brew link` step did not complete successfully"
      puts "The formula built, but is not symlinked into #{HOMEBREW_PREFIX}"
      puts "You can try again using `brew link #{f.name}'"
      puts
      puts "Possible conflicting files are:"
      mode = OpenStruct.new(:dry_run => true, :overwrite => true)
      keg.link(mode)
      ohai e, e.backtrace if ARGV.debug?
      @show_summary_heading = true
      ignore_interrupts{ keg.unlink }
      raise unless e.kind_of? RuntimeError
    end
  end

  def install_plist
    return unless f.plist
    # A plist may already exist if we are installing from a bottle
    f.plist_path.unlink if f.plist_path.exist?
    f.plist_path.write f.plist
    f.plist_path.chmod 0644
  end

  def fix_install_names
    Keg.new(f.prefix).fix_install_names
    if @poured_bottle and f.bottle
      old_prefix = f.bottle.prefix
      new_prefix = HOMEBREW_PREFIX.to_s
      old_cellar = f.bottle.cellar
      new_cellar = HOMEBREW_CELLAR.to_s

      if old_prefix != new_prefix or old_cellar != new_cellar
        Keg.new(f.prefix).relocate_install_names \
          old_prefix, new_prefix, old_cellar, new_cellar
      end
    end
  rescue Exception => e
    onoe "Failed to fix install names"
    puts "The formula built, but you may encounter issues using it or linking other"
    puts "formula against it."
    ohai e, e.backtrace if ARGV.debug?
    @show_summary_heading = true
  end

  def clean
    ohai "Cleaning" if ARGV.verbose?
    if f.class.skip_clean_all?
      opoo "skip_clean :all is deprecated"
      puts "Skip clean was commonly used to prevent brew from stripping binaries."
      puts "brew no longer strips binaries, if skip_clean is required to prevent"
      puts "brew from removing empty directories, you should specify exact paths"
      puts "in the formula."
      return
    end
    Cleaner.new f
  rescue Exception => e
    opoo "The cleaning step did not complete successfully"
    puts "Still, the installation was successful, so we will link it into your prefix"
    ohai e, e.backtrace if ARGV.debug?
    @show_summary_heading = true
  end

  def pour
    downloader = f.downloader
    if downloader.local_bottle_path
      downloader = LocalBottleDownloadStrategy.new f,
                     downloader.local_bottle_path
    else
      fetched = f.fetch
      f.verify_download_integrity fetched
    end
    HOMEBREW_CELLAR.cd do
      downloader.stage
    end
  end

  ## checks

  def print_check_output warning_and_description
    return unless warning_and_description
    warning, description = *warning_and_description
    opoo warning
    puts description
    @show_summary_heading = true
  end

  def audit_bin
    print_check_output(check_PATH(f.bin)) unless f.keg_only?
    print_check_output(check_non_executables(f.bin))
  end

  def audit_sbin
    print_check_output(check_PATH(f.sbin)) unless f.keg_only?
    print_check_output(check_non_executables(f.sbin))
  end

  def audit_lib
    print_check_output(check_jars)
    print_check_output(check_non_libraries)
  end

  def audit_man
    print_check_output(check_manpages)
  end

  def audit_info
    print_check_output(check_infopages)
  end

  private

  def hold_locks?
    @hold_locks || false
  end

  def lock
    if (@@locked ||= []).empty?
      f.recursive_dependencies.each do |dep|
        @@locked << dep.to_formula
      end unless ignore_deps
      @@locked.unshift(f)
      @@locked.each(&:lock)
      @hold_locks = true
    end
  end

  def unlock
    if hold_locks?
      @@locked.each(&:unlock)
      @@locked.clear
      @hold_locks = false
    end
  end
end


class Formula
  def keg_only_text
    s = "This formula is keg-only: so it was not symlinked into #{HOMEBREW_PREFIX}."
    s << "\n\n#{keg_only_reason.to_s}"
    if lib.directory? or include.directory?
      s <<
        <<-EOS.undent_________________________________________________________72


        Generally there are no consequences of this for you. If you build your
        own software and it requires this formula, you'll need to add to your
        build variables:

        EOS
      s << "    LDFLAGS:  -L#{HOMEBREW_PREFIX}/opt/#{name}/lib\n" if lib.directory?
      s << "    CPPFLAGS: -I#{HOMEBREW_PREFIX}/opt/#{name}/include\n" if include.directory?
    end
    s << "\n"
  end
end
