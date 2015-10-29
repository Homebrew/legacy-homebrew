require "cxxstdlib"
require "exceptions"
require "formula"
require "keg"
require "tab"
require "bottles"
require "caveats"
require "cleaner"
require "formula_cellar_checks"
require "install_renamed"
require "cmd/tap"
require "cmd/postinstall"
require "hooks/bottles"
require "debrew"
require "sandbox"
require "requirements/cctools_requirement"

class FormulaInstaller
  include FormulaCellarChecks

  def self.mode_attr_accessor(*names)
    attr_accessor(*names)
    private(*names)
    names.each do |name|
      predicate = "#{name}?"
      define_method(predicate) { !!send(name) }
      private(predicate)
    end
  end

  attr_reader :formula
  attr_accessor :options, :build_bottle
  mode_attr_accessor :show_summary_heading, :show_header
  mode_attr_accessor :build_from_source, :force_bottle
  mode_attr_accessor :ignore_deps, :only_deps, :interactive, :git
  mode_attr_accessor :verbose, :debug, :quieter

  def initialize(formula)
    @formula = formula
    @show_header = false
    @ignore_deps = false
    @only_deps = false
    @build_from_source = false
    @build_bottle = false
    @force_bottle = false
    @interactive = false
    @git = false
    @verbose = false
    @quieter = false
    @debug = false
    @options = Options.new

    @@attempted ||= Set.new

    @poured_bottle = false
    @pour_failed   = false
  end

  def skip_deps_check?
    ignore_deps?
  end

  # When no build tools are available and build flags are passed through ARGV,
  # it's necessary to interrupt the user before any sort of installation
  # can proceed. Only invoked when the user has no developer tools.
  def self.prevent_build_flags
    build_flags = ARGV.collect_build_flags

    raise BuildFlagsError.new(build_flags) unless build_flags.empty?
  end

  def build_bottle?
    !!@build_bottle && !formula.bottle_disabled?
  end

  def pour_bottle?(install_bottle_options = { :warn=>false })
    return true if Homebrew::Hooks::Bottles.formula_has_bottle?(formula)

    return false if @pour_failed

    bottle = formula.bottle
    return true  if force_bottle? && bottle
    return false if build_from_source? || build_bottle? || interactive?
    return false unless options.empty?
    return false if formula.bottle_disabled?
    return true  if formula.local_bottle_path
    return false unless bottle && formula.pour_bottle?

    unless bottle.compatible_cellar?
      if install_bottle_options[:warn]
        opoo "Building source; cellar of #{formula.full_name}'s bottle is #{bottle.cellar}"
      end
      return false
    end

    true
  end

  def install_bottle_for?(dep, build)
    return pour_bottle? if dep == formula
    return false if build_from_source?
    return false unless dep.bottle && dep.pour_bottle?
    return false unless build.used_options.empty?
    return false unless dep.bottle.compatible_cellar?
    true
  end

  def prelude
    verify_deps_exist unless skip_deps_check?
    lock
    check_install_sanity
  end

  def verify_deps_exist
    begin
      formula.recursive_dependencies.map(&:to_formula)
    rescue TapFormulaUnavailableError => e
      if Homebrew.install_tap(e.user, e.repo)
        retry
      else
        raise
      end
    end
  rescue FormulaUnavailableError => e
    e.dependent = formula.full_name
    raise
  end

  def check_install_sanity
    raise FormulaInstallationAlreadyAttemptedError, formula if @@attempted.include?(formula)

    unless skip_deps_check?
      unlinked_deps = formula.recursive_dependencies.map(&:to_formula).select do |dep|
        dep.installed? && !dep.keg_only? && !dep.linked_keg.directory?
      end
      raise CannotInstallFormulaError,
        "You must `brew link #{unlinked_deps*" "}' before #{formula.full_name} can be installed" unless unlinked_deps.empty?
    end
  end

  def build_bottle_preinstall
    @etc_var_glob ||= "#{HOMEBREW_PREFIX}/{etc,var}/**/*"
    @etc_var_preinstall = Dir[@etc_var_glob]
  end

  def build_bottle_postinstall
    @etc_var_postinstall = Dir[@etc_var_glob]
    (@etc_var_postinstall - @etc_var_preinstall).each do |file|
      Pathname.new(file).cp_path_sub(HOMEBREW_PREFIX, formula.bottle_prefix)
    end
  end

  def install
    # not in initialize so upgrade can unlink the active keg before calling this
    # function but after instantiating this class so that it can avoid having to
    # relink the active keg if possible (because it is slow).
    if formula.linked_keg.directory?
      # some other version is already installed *and* linked
      raise CannotInstallFormulaError, <<-EOS.undent
        #{formula.name}-#{formula.linked_keg.resolved_path.basename} already installed
        To install this version, first `brew unlink #{formula.name}'
      EOS
    end

    check_conflicts

    if !pour_bottle? && !formula.bottle_unneeded? && !MacOS.has_apple_developer_tools?
      raise BuildToolsError.new([formula])
    end

    unless skip_deps_check?
      deps = compute_dependencies
      check_dependencies_bottled(deps) if pour_bottle? && !MacOS.has_apple_developer_tools?
      install_dependencies(deps)
    end

    return if only_deps?

    if build_bottle? && (arch = ARGV.bottle_arch) && !Hardware::CPU.optimization_flags.include?(arch)
      raise "Unrecognized architecture for --bottle-arch: #{arch}"
    end

    formula.deprecated_flags.each do |deprecated_option|
      old_flag = deprecated_option.old_flag
      new_flag = deprecated_option.current_flag
      opoo "#{formula.full_name}: #{old_flag} was deprecated; using #{new_flag} instead!"
    end

    oh1 "Installing #{Tty.green}#{formula.full_name}#{Tty.reset}" if show_header?

    @@attempted << formula

    if pour_bottle?(:warn => true)
      begin
        install_relocation_tools unless formula.bottle_specification.skip_relocation?
        pour
      rescue Exception => e
        # any exceptions must leave us with nothing installed
        ignore_interrupts do
          formula.prefix.rmtree if formula.prefix.directory?
          formula.rack.rmdir_if_possible
        end
        raise if ARGV.homebrew_developer?
        @pour_failed = true
        onoe e.message
        opoo "Bottle installation failed: building from source."
        raise BuildToolsError.new([formula]) unless MacOS.has_apple_developer_tools?
      else
        @poured_bottle = true
      end
    end

    build_bottle_preinstall if build_bottle?

    unless @poured_bottle
      compute_and_install_dependencies if @pour_failed && !ignore_deps?
      build
      clean
    end

    build_bottle_postinstall if build_bottle?

    opoo "Nothing was installed to #{formula.prefix}" unless formula.installed?
  end

  def check_conflicts
    return if ARGV.force?

    conflicts = formula.conflicts.select do |c|
      begin
        f = Formulary.factory(c.name)
      rescue TapFormulaUnavailableError
        # If the formula name is in full-qualified name. Let's silently
        # ignore it as we don't care about things used in taps that aren't
        # currently tapped.
        false
      else
        f.linked_keg.exist? && f.opt_prefix.exist?
      end
    end

    raise FormulaConflictError.new(formula, conflicts) unless conflicts.empty?
  end

  # Compute and collect the dependencies needed by the formula currently
  # being installed.
  def compute_dependencies
    req_map, req_deps = expand_requirements
    check_requirements(req_map)
    deps = expand_dependencies(req_deps + formula.deps)

    deps
  end

  # Check that each dependency in deps has a bottle available, terminating
  # abnormally with a BuildToolsError if one or more don't.
  # Only invoked when the user has no developer tools.
  def check_dependencies_bottled(deps)
    unbottled = deps.reject do |dep, _|
      dep_f = dep.to_formula
      dep_f.pour_bottle? || dep_f.bottle_unneeded?
    end

    raise BuildToolsError.new(unbottled) unless unbottled.empty?
  end

  def compute_and_install_dependencies
    deps = compute_dependencies
    install_dependencies(deps)
  end

  def check_requirements(req_map)
    fatals = []

    req_map.each_pair do |dependent, reqs|
      reqs.each do |req|
        puts "#{dependent}: #{req.message}"
        fatals << req if req.fatal?
      end
    end

    raise UnsatisfiedRequirements.new(fatals) unless fatals.empty?
  end

  def install_requirement_default_formula?(req, dependent, build)
    return false unless req.default_formula?
    return true unless req.satisfied?
    return false if req.tags.include?(:run)
    install_bottle_for?(dependent, build) || build_bottle?
  end

  def expand_requirements
    unsatisfied_reqs = Hash.new { |h, k| h[k] = [] }
    deps = []
    formulae = [formula]

    while f = formulae.pop
      f.recursive_requirements do |dependent, req|
        build = effective_build_options_for(dependent)

        if (req.optional? || req.recommended?) && build.without?(req)
          Requirement.prune
        elsif req.build? && install_bottle_for?(dependent, build)
          Requirement.prune
        elsif install_requirement_default_formula?(req, dependent, build)
          dep = req.to_dependency
          deps.unshift(dep)
          formulae.unshift(dep.to_formula)
          Requirement.prune
        elsif req.satisfied?
          Requirement.prune
        else
          unsatisfied_reqs[dependent] << req
        end
      end
    end

    # Merge the repeated dependencies, which may have different tags.
    deps = Dependency.merge_repeats(deps)

    [unsatisfied_reqs, deps]
  end

  def expand_dependencies(deps)
    inherited_options = {}

    expanded_deps = Dependency.expand(formula, deps) do |dependent, dep|
      options = inherited_options[dep.name] = inherited_options_for(dep)
      build = effective_build_options_for(
        dependent,
        inherited_options.fetch(dependent.name, [])
      )

      if (dep.optional? || dep.recommended?) && build.without?(dep)
        Dependency.prune
      elsif dep.build? && install_bottle_for?(dependent, build)
        Dependency.prune
      elsif dep.satisfied?(options)
        Dependency.skip
      end
    end

    expanded_deps.map { |dep| [dep, inherited_options[dep.name]] }
  end

  def effective_build_options_for(dependent, inherited_options = [])
    args  = dependent.build.used_options
    args |= dependent == formula ? options : inherited_options
    args |= Tab.for_formula(dependent).used_options
    BuildOptions.new(args, dependent.options)
  end

  def inherited_options_for(dep)
    inherited_options = Options.new
    u = Option.new("universal")
    if (options.include?(u) || formula.require_universal_deps?) && !dep.build? && dep.to_formula.option_defined?(u)
      inherited_options << u
    end
    inherited_options
  end

  def install_dependencies(deps)
    if deps.empty? && only_deps?
      puts "All dependencies for #{formula.full_name} are satisfied."
    else
      oh1 "Installing dependencies for #{formula.full_name}: #{Tty.green}#{deps.map(&:first)*", "}#{Tty.reset}" unless deps.empty?
      deps.each { |dep, options| install_dependency(dep, options) }
    end

    @show_header = true unless deps.empty?
  end

  # Installs the relocation tools (as provided by the cctools formula) as a hard
  # dependency for every formula installed from a bottle when the user has no
  # developer tools. Invoked unless the formula explicitly sets
  # :any_skip_relocation in its bottle DSL.
  def install_relocation_tools
    cctools = CctoolsRequirement.new
    dependency = cctools.to_dependency
    formula = dependency.to_formula
    return if cctools.satisfied? || @@attempted.include?(formula)

    install_dependency(dependency, inherited_options_for(cctools))
  end

  class DependencyInstaller < FormulaInstaller
    def skip_deps_check?
      true
    end
  end

  def install_dependency(dep, inherited_options)
    df = dep.to_formula
    tab = Tab.for_formula(df)

    if df.linked_keg.directory?
      linked_keg = Keg.new(df.linked_keg.resolved_path)
      linked_keg.unlink
    end

    if df.installed?
      installed_keg = Keg.new(df.prefix)
      tmp_keg = Pathname.new("#{installed_keg}.tmp")
      installed_keg.rename(tmp_keg)
    end

    fi = DependencyInstaller.new(df)
    fi.options           |= tab.used_options
    fi.options           |= Tab.remap_deprecated_options(df.deprecated_options, dep.options)
    fi.options           |= inherited_options
    fi.build_from_source  = build_from_source?
    fi.verbose            = verbose? && !quieter?
    fi.debug              = debug?
    fi.prelude
    oh1 "Installing #{formula.full_name} dependency: #{Tty.green}#{dep.name}#{Tty.reset}"
    fi.install
    fi.finish
  rescue Exception
    ignore_interrupts do
      tmp_keg.rename(installed_keg) if tmp_keg && !installed_keg.directory?
      linked_keg.link if linked_keg
    end
    raise
  else
    ignore_interrupts { tmp_keg.rmtree if tmp_keg && tmp_keg.directory? }
  end

  def caveats
    return if only_deps?

    audit_installed if ARGV.homebrew_developer? && !formula.keg_only?

    c = Caveats.new(formula)

    unless c.empty?
      @show_summary_heading = true
      ohai "Caveats", c.caveats
    end
  end

  def finish
    return if only_deps?

    ohai "Finishing up" if verbose?

    install_plist

    keg = Keg.new(formula.prefix)
    link(keg)

    unless @poured_bottle && formula.bottle_specification.skip_relocation?
      fix_install_names(keg)
    end

    if formula.post_install_defined?
      if build_bottle?
        ohai "Not running post_install as we're building a bottle"
        puts "You can run it manually using `brew postinstall #{formula.full_name}`"
      else
        post_install
      end
    end

    caveats

    ohai "Summary" if verbose? || show_summary_heading?
    puts summary

    # let's reset Utils.git_available? if we just installed git
    Utils.clear_git_available_cache if formula.name == "git"
  ensure
    unlock
  end

  def emoji
    ENV["HOMEBREW_INSTALL_BADGE"] || "\xf0\x9f\x8d\xba"
  end

  def summary
    s = ""
    s << "#{emoji}  " if MacOS.version >= :lion && !ENV["HOMEBREW_NO_EMOJI"]
    s << "#{formula.prefix}: #{formula.prefix.abv}"
    s << ", built in #{pretty_duration build_time}" if build_time
    s
  end

  def build_time
    @build_time ||= Time.now - @start_time if @start_time && !interactive?
  end

  def sanitized_ARGV_options
    args = []
    args << "--ignore-dependencies" if ignore_deps?

    if build_bottle?
      args << "--build-bottle"
      args << "--bottle-arch=#{ARGV.bottle_arch}" if ARGV.bottle_arch
    end

    args << "--git" if git?
    args << "--interactive" if interactive?
    args << "--verbose" if verbose?
    args << "--debug" if debug?
    args << "--cc=#{ARGV.cc}" if ARGV.cc

    if ARGV.env
      args << "--env=#{ARGV.env}"
    elsif formula.env.std? || formula.recursive_dependencies.any? { |d| d.name == "scons" }
      args << "--env=std"
    end

    if formula.head?
      args << "--HEAD"
    elsif formula.devel?
      args << "--devel"
    end

    formula.options.each do |opt|
      name  = opt.name[/\A(.+)=\z$/, 1]
      value = ARGV.value(name)
      args << "--#{name}=#{value}" if name && value
    end

    args
  end

  def build_argv
    sanitized_ARGV_options + options.as_flags
  end

  def build
    FileUtils.rm_rf(formula.logs)

    @start_time = Time.now

    # 1. formulae can modify ENV, so we must ensure that each
    #    installation has a pristine ENV when it starts, forking now is
    #    the easiest way to do this
    args = %W[
      nice #{RUBY_PATH}
      -W0
      -I #{HOMEBREW_LOAD_PATH}
      --
      #{HOMEBREW_LIBRARY_PATH}/build.rb
      #{formula.path}
    ].concat(build_argv)

    if Sandbox.available? && ARGV.sandbox?
      if Sandbox.auto_disable?
        Sandbox.print_autodisable_warning
      else
        Sandbox.print_sandbox_message
      end
    end

    Utils.safe_fork do
      # Invalidate the current sudo timestamp in case a build script calls sudo
      system "/usr/bin/sudo", "-k"

      if Sandbox.available? && ARGV.sandbox? && !Sandbox.auto_disable?
        sandbox = Sandbox.new
        formula.logs.mkpath
        sandbox.record_log(formula.logs/"sandbox.build.log")
        sandbox.allow_write_temp_and_cache
        sandbox.allow_write_log(formula)
        sandbox.allow_write_xcode
        sandbox.allow_write_cellar(formula)
        sandbox.exec(*args)
      else
        exec(*args)
      end
    end

    raise "Empty installation" if Dir["#{formula.prefix}/*"].empty?

  rescue Exception
    ignore_interrupts do
      # any exceptions must leave us with nothing installed
      formula.prefix.rmtree if formula.prefix.directory?
      formula.rack.rmdir_if_possible
    end
    raise
  end

  def link(keg)
    if formula.keg_only?
      begin
        keg.optlink
      rescue Keg::LinkError => e
        onoe "Failed to create #{formula.opt_prefix}"
        puts "Things that depend on #{formula.full_name} will probably not build."
        puts e
        Homebrew.failed = true
      end
      return
    end

    if keg.linked?
      opoo "This keg was marked linked already, continuing anyway"
      keg.remove_linked_keg_record
    end

    link_overwrite_backup = {} # Hash: conflict file -> backup file
    backup_dir = HOMEBREW_CACHE/"Backup"

    begin
      keg.link
    rescue Keg::ConflictError => e
      conflict_file = e.dst
      if formula.link_overwrite?(conflict_file) && !link_overwrite_backup.key?(conflict_file)
        backup_file = backup_dir/conflict_file.relative_path_from(HOMEBREW_PREFIX).to_s
        backup_file.parent.mkpath
        conflict_file.rename backup_file
        link_overwrite_backup[conflict_file] = backup_file
        retry
      end
      onoe "The `brew link` step did not complete successfully"
      puts "The formula built, but is not symlinked into #{HOMEBREW_PREFIX}"
      puts e
      puts
      puts "Possible conflicting files are:"
      mode = OpenStruct.new(:dry_run => true, :overwrite => true)
      keg.link(mode)
      @show_summary_heading = true
      Homebrew.failed = true
    rescue Keg::LinkError => e
      onoe "The `brew link` step did not complete successfully"
      puts "The formula built, but is not symlinked into #{HOMEBREW_PREFIX}"
      puts e
      puts
      puts "You can try again using:"
      puts "  brew link #{formula.name}"
      @show_summary_heading = true
      Homebrew.failed = true
    rescue Exception => e
      onoe "An unexpected error occurred during the `brew link` step"
      puts "The formula built, but is not symlinked into #{HOMEBREW_PREFIX}"
      puts e
      puts e.backtrace if debug?
      @show_summary_heading = true
      ignore_interrupts do
        keg.unlink
        link_overwrite_backup.each do |origin, backup|
          origin.parent.mkpath
          backup.rename origin
        end
      end
      Homebrew.failed = true
      raise
    end

    unless link_overwrite_backup.empty?
      opoo "These files were overwritten during `brew link` step:"
      puts link_overwrite_backup.keys
      puts
      puts "They have been backed up in #{backup_dir}"
      @show_summary_heading = true
    end
  end

  def install_plist
    return unless formula.plist
    formula.plist_path.atomic_write(formula.plist)
    formula.plist_path.chmod 0644
    log = formula.var/"log"
    log.mkpath if formula.plist.include? log.to_s
  rescue Exception => e
    onoe "Failed to install plist file"
    ohai e, e.backtrace if debug?
    Homebrew.failed = true
  end

  def fix_install_names(keg)
    keg.fix_install_names(:keg_only => formula.keg_only?)
  rescue Exception => e
    onoe "Failed to fix install names"
    puts "The formula built, but you may encounter issues using it or linking other"
    puts "formula against it."
    ohai e, e.backtrace if debug?
    Homebrew.failed = true
    @show_summary_heading = true
  end

  def clean
    ohai "Cleaning" if verbose?
    Cleaner.new(formula).clean
  rescue Exception => e
    opoo "The cleaning step did not complete successfully"
    puts "Still, the installation was successful, so we will link it into your prefix"
    ohai e, e.backtrace if debug?
    Homebrew.failed = true
    @show_summary_heading = true
  end

  def post_install
    Homebrew.run_post_install(formula)
  rescue Exception => e
    opoo "The post-install step did not complete successfully"
    puts "You can try again using `brew postinstall #{formula.full_name}`"
    ohai e, e.backtrace if debug?
    Homebrew.failed = true
    @show_summary_heading = true
  end

  def pour
    if Homebrew::Hooks::Bottles.formula_has_bottle?(formula)
      return if Homebrew::Hooks::Bottles.pour_formula_bottle(formula)
    end

    if (bottle_path = formula.local_bottle_path)
      downloader = LocalBottleDownloadStrategy.new(bottle_path)
    else
      downloader = formula.bottle
      downloader.verify_download_integrity(downloader.fetch)
    end
    HOMEBREW_CELLAR.cd do
      downloader.stage
    end

    keg = Keg.new(formula.prefix)
    unless formula.bottle_specification.skip_relocation?
      keg.relocate_install_names Keg::PREFIX_PLACEHOLDER, HOMEBREW_PREFIX.to_s,
        Keg::CELLAR_PLACEHOLDER, HOMEBREW_CELLAR.to_s, :keg_only => formula.keg_only?
    end
    keg.relocate_text_files Keg::PREFIX_PLACEHOLDER, HOMEBREW_PREFIX.to_s,
      Keg::CELLAR_PLACEHOLDER, HOMEBREW_CELLAR.to_s

    Pathname.glob("#{formula.bottle_prefix}/{etc,var}/**/*") do |path|
      path.extend(InstallRenamed)
      path.cp_path_sub(formula.bottle_prefix, HOMEBREW_PREFIX)
    end
    FileUtils.rm_rf formula.bottle_prefix

    tab = Tab.for_keg(formula.prefix)

    CxxStdlib.check_compatibility(
      formula, formula.recursive_dependencies,
      Keg.new(formula.prefix), tab.compiler
    )

    tab.tap = formula.tap
    tab.poured_from_bottle = true
    tab.write
  end

  def audit_check_output(output)
    if output
      opoo output
      @show_summary_heading = true
    end
  end

  def audit_installed
    audit_check_output(check_PATH(formula.bin))
    audit_check_output(check_PATH(formula.sbin))
    super
  end

  private

  def hold_locks?
    @hold_locks || false
  end

  def lock
    if (@@locked ||= []).empty?
      formula.recursive_dependencies.each do |dep|
        @@locked << dep.to_formula
      end unless ignore_deps?
      @@locked.unshift(formula)
      @@locked.uniq!
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
