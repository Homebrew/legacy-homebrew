require 'formula_support'
require 'formula_lock'
require 'formula_pin'
require 'hardware'
require 'bottles'
require 'build_environment'
require 'build_options'
require 'formulary'
require 'software_spec'
require 'install_renamed'
require 'pkg_version'
require 'tap'

# A formula provides instructions and metadata for Homebrew to install a piece
# of software. Every Homebrew formula is a {Formula}.
# All subclasses of {Formula} (and all Ruby classes) have to be named
# `UpperCase` and `not-use-dashes`.
# A formula specified in `this-formula.rb` should have a class named
# `ThisFormula`. Homebrew does enforce that the name of the file and the class
# correspond.
# Make sure you check with `brew search` that the name is free!
# @abstract
class Formula
  include FileUtils
  include Utils::Inreplace
  extend Enumerable

  # The name of this {Formula}.
  # e.g. `this-formula`
  attr_reader :name

  # The fully-qualified name of this {Formula}.
  # For core formula it's the same as {#name}.
  # e.g. `homebrew/tap-name/this-formula`
  attr_reader :full_name

  # The full path to this {Formula}.
  # e.g. `/usr/local/Library/Formula/this-formula.rb`
  attr_reader :path

  # The stable (and default) {SoftwareSpec} for this {Formula}
  # This contains all the attributes (e.g. URL, checksum) that apply to the
  # stable version of this formula.
  attr_reader :stable

  # The development {SoftwareSpec} for this {Formula}.
  # Installed when using `brew install --devel`
  # `nil` if there is no development version.
  # @see #stable
  attr_reader :devel

  # The HEAD {SoftwareSpec} for this {Formula}.
  # Installed when using `brew install --HEAD`
  # This is always installed with the version `HEAD` and taken from the latest
  # commit in the version control system.
  # `nil` if there is no HEAD version.
  # @see #stable
  attr_reader :head

  # The currently active {SoftwareSpec}.
  # @see #determine_active_spec
  attr_reader :active_spec
  protected :active_spec

  # The {PkgVersion} for this formula with version and {#revision} information.
  attr_reader :pkg_version

  # Used for creating new Homebrew versions of software without new upstream
  # versions.
  # @see .revision
  attr_reader :revision

  # The current working directory during builds.
  # Will only be non-`nil` inside {#install}.
  attr_reader :buildpath

  # The current working directory during tests.
  # Will only be non-`nil` inside {#test}.
  attr_reader :testpath

  # When installing a bottle (binary package) from a local path this will be
  # set to the full path to the bottle tarball. If not, it will be `nil`.
  attr_accessor :local_bottle_path

  # The {BuildOptions} for this {Formula}. Lists the arguments passed and any
  # {#options} in the {Formula}. Note that these may differ at different times
  # during the installation of a {Formula}. This is annoying but the result of
  # state that we're trying to eliminate.
  attr_accessor :build

  # @private
  def initialize(name, path, spec)
    @name = name
    @path = path
    @revision = self.class.revision || 0

    if path.to_s =~ HOMEBREW_TAP_PATH_REGEX
      @full_name = "#{$1}/#{$2.gsub(/^homebrew-/, "")}/#{name}"
    else
      @full_name = name
    end

    set_spec :stable
    set_spec :devel
    set_spec :head

    @active_spec = determine_active_spec(spec)
    validate_attributes!
    @pkg_version = PkgVersion.new(version, revision)
    @build = active_spec.build
    @pin = FormulaPin.new(self)
  end

  private

  def set_spec(name)
    spec = self.class.send(name)
    if spec.url
      spec.owner = self
      instance_variable_set("@#{name}", spec)
    end
  end

  def determine_active_spec(requested)
    spec = send(requested) || stable || devel || head
    spec or raise FormulaSpecificationError, "formulae require at least a URL"
  end

  def validate_attributes!
    if name.nil? || name.empty? || name =~ /\s/
      raise FormulaValidationError.new(:name, name)
    end

    url = active_spec.url
    if url.nil? || url.empty? || url =~ /\s/
      raise FormulaValidationError.new(:url, url)
    end

    val = version.respond_to?(:to_str) ? version.to_str : version
    if val.nil? || val.empty? || val =~ /\s/
      raise FormulaValidationError.new(:version, val)
    end
  end

  public

  # Is the currently active {SoftwareSpec} a {#stable} build?
  def stable?
    active_spec == stable
  end

  # Is the currently active {SoftwareSpec} a {#devel} build?
  def devel?
    active_spec == devel
  end

  # Is the currently active {SoftwareSpec} a {#head} build?
  def head?
    active_spec == head
  end

  # @private
  def bottled?
    active_spec.bottled?
  end

  # @private
  def bottle_specification
    active_spec.bottle_specification
  end

  # The Bottle object for the currently active {SoftwareSpec}.
  # @private
  def bottle
    Bottle.new(self, bottle_specification) if bottled?
  end

  # The description of the software.
  # @see .desc
  def desc
    self.class.desc
  end

  # The homepage for the software.
  # @see .homepage
  def homepage
    self.class.homepage
  end

  # The version for the currently active {SoftwareSpec}.
  # The version is autodetected from the URL and/or tag so only needs to be
  # declared if it cannot be autodetected correctly.
  # @see .version
  def version
    active_spec.version
  end

  # A named Resource for the currently active {SoftwareSpec}.
  def resource(name)
    active_spec.resource(name)
  end

  # The {Resource}s for the currently active {SoftwareSpec}.
  def resources
    active_spec.resources.values
  end

  # The {Dependency}s for the currently active {SoftwareSpec}.
  def deps
    active_spec.deps
  end

  # The {Requirement}s for the currently active {SoftwareSpec}.
  def requirements
    active_spec.requirements
  end

  # The cached download for the currently active {SoftwareSpec}.
  def cached_download
    active_spec.cached_download
  end

  # Deletes the download for the currently active {SoftwareSpec}.
  def clear_cache
    active_spec.clear_cache
  end

  # The list of patches for the currently active {SoftwareSpec}.
  def patchlist
    active_spec.patches
  end

  # The options for the currently active {SoftwareSpec}.
  def options
    active_spec.options
  end

  # The deprecated options for the currently active {SoftwareSpec}.
  def deprecated_options
    active_spec.deprecated_options
  end

  def deprecated_flags
    active_spec.deprecated_flags
  end

  # If a named option is defined for the currently active {SoftwareSpec}.
  def option_defined?(name)
    active_spec.option_defined?(name)
  end

  # All the {.fails_with} for the currently active {SoftwareSpec}.
  def compiler_failures
    active_spec.compiler_failures
  end

  # If this {Formula} is installed.
  # This is actually just a check for if the {#installed_prefix} directory
  # exists and is not empty.
  def installed?
    (dir = installed_prefix).directory? && dir.children.length > 0
  end

  # @private
  # The `LinkedKegs` directory for this {Formula}.
  # You probably want {#opt_prefix} instead.
  def linked_keg
    Pathname.new("#{HOMEBREW_LIBRARY}/LinkedKegs/#{name}")
  end

  # The latest prefix for this formula. Checks for {#head}, then {#devel}
  # and then {#stable}'s {#prefix}
  def installed_prefix
    if head && (head_prefix = prefix(head.version)).directory?
      head_prefix
    elsif devel && (devel_prefix = prefix(devel.version)).directory?
      devel_prefix
    else
      prefix
    end
  end

  # The currently installed version for this formula. Will raise an exception
  # if the formula is not installed.
  def installed_version
    require 'keg'
    Keg.new(installed_prefix).version
  end

  # The directory in the cellar that the formula is installed to.
  # This directory contains the formula's name and version.
  def prefix(v=pkg_version)
    Pathname.new("#{HOMEBREW_CELLAR}/#{name}/#{v}")
  end

  # The parent of the prefix; the named directory in the cellar containing all
  # installed versions of this software
  def rack; prefix.parent end

  # The directory where the formula's binaries should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def bin;     prefix+'bin'     end

  # The directory where the formula's documentation should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def doc;     share+'doc'+name end

  # The directory where the formula's headers should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def include; prefix+'include' end

  # The directory where the formula's info files should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def info;    share+'info'     end

  # The directory where the formula's libraries should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def lib;     prefix+'lib'     end

  # The directory where the formula's binaries should be installed.
  # This is not symlinked into `HOMEBREW_PREFIX`.
  # It is also commonly used to install files that we do not wish to be
  # symlinked into HOMEBREW_PREFIX from one of the other directories and
  # instead manually create symlinks or wrapper scripts into e.g. {#bin}.
  def libexec; prefix+'libexec' end

  # The root directory where the formula's manual pages should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  # Often one of the more specific `man` functions should be used instead
  # e.g. {#man1}
  def man;     share+'man'      end

  # The directory where the formula's man1 pages should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def man1;    man+'man1'       end

  # The directory where the formula's man2 pages should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def man2;    man+'man2'       end

  # The directory where the formula's man3 pages should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def man3;    man+'man3'       end

  # The directory where the formula's man4 pages should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def man4;    man+'man4'       end

  # The directory where the formula's man5 pages should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def man5;    man+'man5'       end

  # The directory where the formula's man6 pages should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def man6;    man+'man6'       end

  # The directory where the formula's man7 pages should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def man7;    man+'man7'       end

  # The directory where the formula's man8 pages should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def man8;    man+'man8'       end

  # The directory where the formula's `sbin` binaries should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  # Generally we try to migrate these to {#bin} instead.
  def sbin;    prefix+'sbin'    end

  # The directory where the formula's shared files should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def share;   prefix+'share'   end

  # The directory where the formula's shared files should be installed,
  # with the name of the formula appended to avoid linking conflicts.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def pkgshare;    prefix+'share'+name    end

  # The directory where the formula's Frameworks should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  # This is not symlinked into `HOMEBREW_PREFIX`.
  def frameworks; prefix+'Frameworks' end

  # The directory where the formula's kernel extensions should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  # This is not symlinked into `HOMEBREW_PREFIX`.
  def kext_prefix; prefix+'Library/Extensions' end

  # The directory where the formula's configuration files should be installed.
  # Anything using `etc.install` will not overwrite other files on e.g. upgrades
  # but will write a new file named `*.default`.
  # This directory is not inside the `HOMEBREW_CELLAR` so it is persisted
  # across upgrades.
  def etc; (HOMEBREW_PREFIX+'etc').extend(InstallRenamed) end

  # The directory where the formula's variable files should be installed.
  # This directory is not inside the `HOMEBREW_CELLAR` so it is persisted
  # across upgrades.
  def var; HOMEBREW_PREFIX+'var' end

  # The directory where the formula's Bash completion files should be
  # installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def bash_completion; prefix+'etc/bash_completion.d'    end

  # The directory where the formula's ZSH completion files should be
  # installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def zsh_completion;  share+'zsh/site-functions'        end

  # The directory where the formula's fish completion files should be
  # installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def fish_completion; share+'fish/vendor_completions.d' end

  # The directory used for as the prefix for {#etc} and {#var} files on
  # installation so, despite not being in `HOMEBREW_CELLAR`, they are installed
  # there after pouring a bottle.
  def bottle_prefix; prefix+'.bottle' end

  def logs
    HOMEBREW_LOGS+name
  end

  # override this to provide a plist
  def plist; nil; end
  alias :startup_plist :plist
  # plist name, i.e. the name of the launchd service
  def plist_name; 'homebrew.mxcl.'+name end
  def plist_path; prefix+(plist_name+'.plist') end
  def plist_manual; self.class.plist_manual end
  def plist_startup; self.class.plist_startup end

  # A stable path for this formula, when installed. Contains the formula name
  # but no version number. Only the active version will be linked here if
  # multiple versions are installed.
  #
  # This is the prefered way to refer a formula in plists or from another
  # formula, as the path is stable even when the software is updated.
  def opt_prefix
    Pathname.new("#{HOMEBREW_PREFIX}/opt/#{name}")
  end

  def opt_bin;     opt_prefix+'bin'     end
  def opt_include; opt_prefix+'include' end
  def opt_lib;     opt_prefix+'lib'     end
  def opt_libexec; opt_prefix+'libexec' end
  def opt_sbin;    opt_prefix+'sbin'    end
  def opt_share;   opt_prefix+'share'   end
  def opt_frameworks; opt_prefix+'Frameworks' end

  # Can be overridden to selectively disable bottles from formulae.
  # Defaults to true so overridden version does not have to check if bottles
  # are supported.
  def pour_bottle?; true end

  # Can be overridden to run commands on both source and bottle installation.
  def post_install; end

  def post_install_defined?
    method(:post_install).owner == self.class
  end

  # @private
  def run_post_install
    build, self.build = self.build, Tab.for_formula(self)
    post_install
  ensure
    self.build = build
  end

  # tell the user about any caveats regarding this package, return a string
  def caveats; nil end

  # rarely, you don't want your library symlinked into the main prefix
  # see gettext.rb for an example
  def keg_only?
    keg_only_reason && keg_only_reason.valid?
  end

  def keg_only_reason
    self.class.keg_only_reason
  end

  # sometimes the formula cleaner breaks things
  # skip cleaning paths in a formula with a class method like this:
  #   skip_clean "bin/foo", "lib/bar"
  # keep .la files with:
  #   skip_clean :la
  def skip_clean? path
    return true if path.extname == '.la' and self.class.skip_clean_paths.include? :la
    to_check = path.relative_path_from(prefix).to_s
    self.class.skip_clean_paths.include? to_check
  end

  def skip_cxxstdlib_check?
    false
  end

  def require_universal_deps?
    false
  end

  def patch
    unless patchlist.empty?
      ohai "Patching"
      patchlist.each(&:apply)
    end
  end

  # yields self with current working directory set to the uncompressed tarball
  # @private
  def brew
    stage do
      prepare_patches

      begin
        yield self
      ensure
        cp Dir["config.log", "CMakeCache.txt"], logs
      end
    end
  end

  def lock
    @lock = FormulaLock.new(name)
    @lock.lock
  end

  def unlock
    @lock.unlock unless @lock.nil?
  end

  def pinnable?
    @pin.pinnable?
  end

  def pinned?
    @pin.pinned?
  end

  def pin
    @pin.pin
  end

  def unpin
    @pin.unpin
  end

  def == other
    instance_of?(other.class) &&
      name == other.name &&
      active_spec == other.active_spec
  end
  alias_method :eql?, :==

  def hash
    name.hash
  end

  def <=>(other)
    return unless Formula === other
    name <=> other.name
  end

  def to_s
    name
  end

  def inspect
    s = "#<Formula #{name} ("
    s << if head? then "head" elsif devel? then "devel" else "stable" end
    s << ") #{path}>"
  end

  def file_modified?
    return false unless which("git")
    path.parent.cd do
      diff = Utils.popen_read("git", "diff", "origin/master", "--", "#{path}")
      !diff.empty? && $?.exitstatus == 0
    end
  end

  # Standard parameters for CMake builds.
  # Setting CMAKE_FIND_FRAMEWORK to "LAST" tells CMake to search for our
  # libraries before trying to utilize Frameworks, many of which will be from
  # 3rd party installs.
  # Note: there isn't a std_autotools variant because autotools is a lot
  # less consistent and the standard parameters are more memorable.
  def std_cmake_args
    %W[
      -DCMAKE_C_FLAGS_RELEASE=
      -DCMAKE_CXX_FLAGS_RELEASE=
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_FIND_FRAMEWORK=LAST
      -DCMAKE_VERBOSE_MAKEFILE=ON
      -Wno-dev
    ]
  end

  # an array of all core {Formula} names
  def self.core_names
    @core_names ||= Dir["#{HOMEBREW_LIBRARY}/Formula/*.rb"].map{ |f| File.basename f, ".rb" }.sort
  end

  # an array of all tap {Formula} names
  def self.tap_names
    @tap_names ||= Tap.map(&:formula_names).flatten.sort
  end

  # an array of all {Formula} names
  def self.names
    @names ||= (core_names + tap_names.map { |name| name.split("/")[-1] }).sort.uniq
  end

  # an array of all {Formula} names, which the tap formulae have the fully-qualified name
  def self.full_names
    @full_names ||= core_names + tap_names
  end

  def self.each
    full_names.each do |name|
      begin
        yield Formulary.factory(name)
      rescue StandardError => e
        # Don't let one broken formula break commands. But do complain.
        onoe "Failed to import: #{name}"
        puts e
        next
      end
    end
  end

  # An array of all installed {Formula}
  def self.installed
    @installed ||= if HOMEBREW_CELLAR.directory?
      HOMEBREW_CELLAR.subdirs.map do |rack|
        begin
          Formulary.from_rack(rack)
        rescue FormulaUnavailableError, TapFormulaAmbiguityError
        end
      end.compact
    else
      []
    end
  end

  def self.aliases
    Dir["#{HOMEBREW_LIBRARY}/Aliases/*"].map{ |f| File.basename f }.sort
  end

  def self.[](name)
    Formulary.factory(name)
  end

  def tap?
    HOMEBREW_TAP_DIR_REGEX === path
  end

  def tap
    if path.to_s =~ HOMEBREW_TAP_DIR_REGEX
      "#$1/#$2"
    elsif core_formula?
      "Homebrew/homebrew"
    end
  end

  def print_tap_action options={}
    if tap?
      verb = options[:verb] || "Installing"
      ohai "#{verb} #{name} from #{tap}"
    end
  end

  # True if this formula is provided by Homebrew itself
  def core_formula?
    path == Formulary.core_path(name)
  end

  def env
    self.class.env
  end

  def conflicts
    self.class.conflicts
  end

  # Returns a list of Dependency objects in an installable order, which
  # means if a depends on b then b will be ordered before a in this list
  def recursive_dependencies(&block)
    Dependency.expand(self, &block)
  end

  # The full set of Requirements for this formula's dependency tree.
  def recursive_requirements(&block)
    Requirement.expand(self, &block)
  end

  def to_hash
    hsh = {
      "name" => name,
      "full_name" => full_name,
      "desc" => desc,
      "homepage" => homepage,
      "versions" => {
        "stable" => (stable.version.to_s if stable),
        "bottle" => bottle ? true : false,
        "devel" => (devel.version.to_s if devel),
        "head" => (head.version.to_s if head)
      },
      "revision" => revision,
      "installed" => [],
      "linked_keg" => (linked_keg.resolved_path.basename.to_s if linked_keg.exist?),
      "keg_only" => keg_only?,
      "dependencies" => deps.map(&:name).uniq,
      "conflicts_with" => conflicts.map(&:name),
      "caveats" => caveats
    }

    hsh["requirements"] = requirements.map do |req|
      {
        "name" => req.name,
        "default_formula" => req.default_formula,
        "cask" => req.cask,
        "download" => req.download
      }
    end

    hsh["options"] = options.map { |opt|
      { "option" => opt.flag, "description" => opt.description }
    }

    if rack.directory?
      rack.subdirs.each do |keg_path|
        keg = Keg.new keg_path
        tab = Tab.for_keg keg_path

        hsh["installed"] << {
          "version" => keg.version.to_s,
          "used_options" => tab.used_options.as_flags,
          "built_as_bottle" => tab.built_bottle,
          "poured_from_bottle" => tab.poured_from_bottle
        }
      end

      hsh["installed"] = hsh["installed"].sort_by { |i| Version.new(i["version"]) }
    end

    hsh

  end

  def fetch
    active_spec.fetch
  end

  def verify_download_integrity fn
    active_spec.verify_download_integrity(fn)
  end

  def run_test
    old_home = ENV["HOME"]
    build, self.build = self.build, Tab.for_formula(self)
    mktemp do
      @testpath = Pathname.pwd
      ENV["HOME"] = @testpath
      setup_test_home @testpath
      test
    end
  ensure
    @testpath = nil
    self.build = build
    ENV["HOME"] = old_home
  end

  def test_defined?
    false
  end

  def test
  end

  def test_fixtures(file)
    HOMEBREW_LIBRARY.join("Homebrew", "test", "fixtures", file)
  end

  def install
  end

  protected

  def setup_test_home home
    # keep Homebrew's site-packages in sys.path when testing with system Python
    user_site_packages = home/"Library/Python/2.7/lib/python/site-packages"
    user_site_packages.mkpath
    (user_site_packages/"homebrew.pth").write <<-EOS.undent
      import site; site.addsitedir("#{HOMEBREW_PREFIX}/lib/python2.7/site-packages")
      import sys; sys.path.insert(0, "#{HOMEBREW_PREFIX}/lib/python2.7/site-packages")
    EOS
  end

  # Pretty titles the command and buffers stdout/stderr
  # Throws if there's an error
  def system cmd, *args
    verbose = ARGV.verbose?
    # remove "boring" arguments so that the important ones are more likely to
    # be shown considering that we trim long ohai lines to the terminal width
    pretty_args = args.dup
    if cmd == "./configure" and not verbose
      pretty_args.delete "--disable-dependency-tracking"
      pretty_args.delete "--disable-debug"
    end
    pretty_args.each_index do |i|
      if pretty_args[i].to_s.start_with? "import setuptools"
        pretty_args[i] = "import setuptools..."
      end
    end
    ohai "#{cmd} #{pretty_args*' '}".strip

    @exec_count ||= 0
    @exec_count += 1
    logfn = "#{logs}/%02d.%s" % [@exec_count, File.basename(cmd).split(' ').first]
    logs.mkpath

    File.open(logfn, "w") do |log|
      log.puts Time.now, "", cmd, args, ""
      log.flush

      if verbose
        rd, wr = IO.pipe
        begin
          pid = fork do
            rd.close
            log.close
            exec_cmd(cmd, args, wr, logfn)
          end
          wr.close

          while buf = rd.gets
            log.puts buf
            puts buf
          end
        ensure
          rd.close
        end
      else
        pid = fork { exec_cmd(cmd, args, log, logfn) }
      end

      Process.wait(pid)

      $stdout.flush

      unless $?.success?
        log.flush
        Kernel.system "/usr/bin/tail", "-n", "5", logfn unless verbose
        log.puts

        require "cmd/config"
        require "cmd/--env"

        env = ENV.to_hash

        Homebrew.dump_verbose_config(log)
        log.puts
        Homebrew.dump_build_env(env, log)

        raise BuildError.new(self, cmd, args, env)
      end
    end
  end

  private

  def exec_cmd(cmd, args, out, logfn)
    ENV['HOMEBREW_CC_LOG_PATH'] = logfn

    # TODO system "xcodebuild" is deprecated, this should be removed soon.
    if cmd.to_s.start_with? "xcodebuild"
      ENV.remove_cc_etc
    end

    # Turn on argument filtering in the superenv compiler wrapper.
    # We should probably have a better mechanism for this than adding
    # special cases to this method.
    if cmd == "python"
      setup_py_in_args = %w[setup.py build.py].include?(args.first)
      setuptools_shim_in_args = args.any? { |a| a.to_s.start_with? "import setuptools" }
      if setup_py_in_args || setuptools_shim_in_args
        ENV.refurbish_args
      end
    end

    $stdout.reopen(out)
    $stderr.reopen(out)
    out.close
    args.collect!{|arg| arg.to_s}
    exec(cmd, *args) rescue nil
    puts "Failed to execute: #{cmd}"
    exit! 1 # never gets here unless exec threw or failed
  end

  def stage
    active_spec.stage do
      @buildpath = Pathname.pwd
      env_home = buildpath/".brew_home"
      mkdir_p env_home

      old_home, ENV["HOME"] = ENV["HOME"], env_home

      begin
        yield
      ensure
        @buildpath = nil
        ENV["HOME"] = old_home
      end
    end
  end

  def prepare_patches
    active_spec.add_legacy_patches(patches) if respond_to?(:patches)

    patchlist.grep(DATAPatch) { |p| p.path = path }

    patchlist.select(&:external?).each do |patch|
      patch.verify_download_integrity(patch.fetch)
    end
  end

  def self.method_added method
    case method
    when :brew
      raise "You cannot override Formula#brew in class #{name}"
    when :test
      define_method(:test_defined?) { true }
    when :options
      instance = allocate

      specs.each do |spec|
        instance.options.each do |opt, desc|
          spec.option(opt[/^--(.+)$/, 1], desc)
        end
      end

      remove_method(:options)
    end
  end

  # The methods below define the formula DSL.
  class << self
    include BuildEnvironmentDSL

    # The reason for why this software is not linked (by default) to
    # {::HOMEBREW_PREFIX}.
    # @private
    attr_reader :keg_only_reason

    # @!attribute [w]
    # A one-line description of the software. Used by users to get an overview
    # of the software and Homebrew maintainers.
    # Shows when running `brew info`.
    attr_rw :desc

    # @!attribute [w]
    # The homepage for the software. Used by users to get more information
    # about the software and Homebrew maintainers as a point of contact for
    # e.g. submitting patches.
    # Can be opened with running `brew home`.
    attr_rw :homepage

    # The `:startup` attribute set by {.plist_options}.
    # @private
    attr_reader :plist_startup

    # The `:manual` attribute set by {.plist_options}.
    # @private
    attr_reader :plist_manual

    # @!attribute [w]
    # Used for creating new Homebrew versions of software without new upstream
    # versions. For example, if we bump the major version of a library this
    # {Formula} {.depends_on} then we may need to update the `revision` of this
    # {Formula} to install a new version linked against the new library version.
    # `0` if unset.
    attr_rw :revision

    # A list of the {.stable}, {.devel} and {.head} {SoftwareSpec}s.
    # @private
    def specs
      @specs ||= [stable, devel, head].freeze
    end

    # @!attribute [w] url
    # The URL used to download the source for the {#stable} version of the formula.
    # We prefer `https` for security and proxy reasons.
    def url val, specs={}
      stable.url(val, specs)
    end

    # @!attribute [w] version
    # The version string for the {#stable} version of the formula.
    # The version is autodetected from the URL and/or tag so only needs to be
    # declared if it cannot be autodetected correctly.
    def version val=nil
      stable.version(val)
    end

    # @!attribute [w] mirror
    # Additional URLs for the {#stable} version of the formula.
    # These are only used if the {.url} fails to download. It's optional and
    # there can be more than one. Generally we add them when the main {.url}
    # is unreliable. If {.url} is really unreliable then we may swap the
    # {.mirror} and {.url}.
    def mirror val
      stable.mirror(val)
    end

    # @!attribute [w] sha1
    # @scope class
    # To verify the {#cached_download}'s integrity and security we verify the
    # SHA-1 hash matches what we've declared in the {Formula}. To quickly fill
    # this value you can leave it blank and run `brew fetch --force` and it'll
    # tell you the currently valid value.

    # @!attribute [w] sha256
    # @scope class
    # Similar to {.sha1} but using a SHA-256 hash instead.

    Checksum::TYPES.each do |type|
      define_method(type) { |val| stable.send(type, val) }
    end

    def bottle *, &block
      stable.bottle(&block)
    end

    def build
      stable.build
    end

    def stable &block
      @stable ||= SoftwareSpec.new
      return @stable unless block_given?
      @stable.instance_eval(&block)
    end

    def devel &block
      @devel ||= SoftwareSpec.new
      return @devel unless block_given?
      @devel.instance_eval(&block)
    end

    def head val=nil, specs={}, &block
      @head ||= HeadSoftwareSpec.new
      if block_given?
        @head.instance_eval(&block)
      elsif val
        @head.url(val, specs)
      else
        @head
      end
    end

    # Define a named resource using a {SoftwareSpec} style block
    def resource name, klass=Resource, &block
      specs.each do |spec|
        spec.resource(name, klass, &block) unless spec.resource_defined?(name)
      end
    end

    def go_resource name, &block
      specs.each { |spec| spec.go_resource(name, &block) }
    end

    def depends_on dep
      specs.each { |spec| spec.depends_on(dep) }
    end

    def option name, description=""
      specs.each { |spec| spec.option(name, description) }
    end

    def deprecated_option hash
      specs.each { |spec| spec.deprecated_option(hash) }
    end

    def patch strip=:p1, src=nil, &block
      specs.each { |spec| spec.patch(strip, src, &block) }
    end

    def plist_options options
      @plist_startup = options[:startup]
      @plist_manual = options[:manual]
    end

    def conflicts
      @conflicts ||= []
    end

    def conflicts_with *names
      opts = Hash === names.last ? names.pop : {}
      names.each { |name| conflicts << FormulaConflict.new(name, opts[:because]) }
    end

    def skip_clean *paths
      paths.flatten!
      # Specifying :all is deprecated and will become an error
      skip_clean_paths.merge(paths)
    end

    def skip_clean_paths
      @skip_clean_paths ||= Set.new
    end

    def keg_only reason, explanation=""
      @keg_only_reason = KegOnlyReason.new(reason, explanation)
    end

    # Pass :skip to this method to disable post-install stdlib checking
    def cxxstdlib_check check_type
      define_method(:skip_cxxstdlib_check?) { true } if check_type == :skip
    end

    # For Apple compilers, this should be in the format:
    # fails_with compiler do
    #   cause "An explanation for why the build doesn't work."
    #   build "The Apple build number for the newest incompatible release."
    # end
    #
    # The block may be omitted, and if present the build may be omitted;
    # if so, then the compiler will be blacklisted for *all* versions.
    #
    # For GNU GCC compilers, this should be in the format:
    # fails_with compiler => major_version do
    #   cause
    #   version "The official release number for the latest incompatible
    #            version, for instance 4.8.1"
    # end
    #
    # `major_version` should be the major release number only, for instance
    # '4.8' for the GCC 4.8 series (4.8.0, 4.8.1, etc.).
    # If `version` or the block is omitted, then the compiler will be
    # blacklisted for all compilers in that series.
    #
    # For example, if a bug is only triggered on GCC 4.8.1 but is not
    # encountered on 4.8.2:
    #
    # fails_with :gcc => '4.8' do
    #   version '4.8.1'
    # end
    def fails_with compiler, &block
      specs.each { |spec| spec.fails_with(compiler, &block) }
    end

    def needs *standards
      specs.each { |spec| spec.needs(*standards) }
    end

    def test &block
      define_method(:test, &block)
    end
  end
end
