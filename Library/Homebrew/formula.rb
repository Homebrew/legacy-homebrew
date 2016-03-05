require "formula_support"
require "formula_lock"
require "formula_pin"
require "hardware"
require "bottles"
require "build_environment"
require "build_options"
require "formulary"
require "software_spec"
require "install_renamed"
require "pkg_version"
require "tap"
require "core_formula_repository"
require "keg"
require "migrator"

# A formula provides instructions and metadata for Homebrew to install a piece
# of software. Every Homebrew formula is a {Formula}.
# All subclasses of {Formula} (and all Ruby classes) have to be named
# `UpperCase` and `not-use-dashes`.
# A formula specified in `this-formula.rb` should have a class named
# `ThisFormula`. Homebrew does enforce that the name of the file and the class
# correspond.
# Make sure you check with `brew search` that the name is free!
# @abstract
# @see SharedEnvExtension
# @see FileUtils
# @see Pathname
# @see http://www.rubydoc.info/github/Homebrew/homebrew/file/share/doc/homebrew/Formula-Cookbook.md Formula Cookbook
# @see https://github.com/styleguide/ruby Ruby Style Guide
#
# <pre>class Wget < Formula
#   homepage "https://www.gnu.org/software/wget/"
#   url "https://ftp.gnu.org/gnu/wget/wget-1.15.tar.gz"
#   sha256 "52126be8cf1bddd7536886e74c053ad7d0ed2aa89b4b630f76785bac21695fcd"
#
#   def install
#     system "./configure", "--prefix=#{prefix}"
#     system "make", "install"
#   end
# end</pre>
class Formula
  include FileUtils
  include Utils::Inreplace
  extend Enumerable

  # @!method inreplace(paths, before = nil, after = nil)
  # Actually implemented in {Utils::Inreplace.inreplace}.
  # Sometimes we have to change a bit before we install. Mostly we
  # prefer a patch but if you need the `prefix` of this formula in the
  # patch you have to resort to `inreplace`, because in the patch
  # you don't have access to any var defined by the formula. Only
  # HOMEBREW_PREFIX is available in the embedded patch.
  # inreplace supports regular expressions.
  # <pre>inreplace "somefile.cfg", /look[for]what?/, "replace by #{bin}/tool"</pre>
  # @see Utils::Inreplace.inreplace

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

  # The {Tap} instance associated with this {Formula}.
  # If it's <code>nil</code>, then this formula is loaded from path or URL.
  # @private
  attr_reader :tap

  # The stable (and default) {SoftwareSpec} for this {Formula}
  # This contains all the attributes (e.g. URL, checksum) that apply to the
  # stable version of this formula.
  # @private
  attr_reader :stable

  # The development {SoftwareSpec} for this {Formula}.
  # Installed when using `brew install --devel`
  # `nil` if there is no development version.
  # @see #stable
  # @private
  attr_reader :devel

  # The HEAD {SoftwareSpec} for this {Formula}.
  # Installed when using `brew install --HEAD`
  # This is always installed with the version `HEAD` and taken from the latest
  # commit in the version control system.
  # `nil` if there is no HEAD version.
  # @see #stable
  # @private
  attr_reader :head

  # The currently active {SoftwareSpec}.
  # @see #determine_active_spec
  attr_reader :active_spec
  protected :active_spec

  # A symbol to indicate currently active {SoftwareSpec}.
  # It's either :stable, :devel or :head
  # @see #active_spec
  # @private
  attr_reader :active_spec_sym

  # most recent modified time for source files
  # @private
  attr_reader :source_modified_time

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
  # @private
  attr_accessor :local_bottle_path

  # The {BuildOptions} for this {Formula}. Lists the arguments passed and any
  # {#options} in the {Formula}. Note that these may differ at different times
  # during the installation of a {Formula}. This is annoying but the result of
  # state that we're trying to eliminate.
  # @return [BuildOptions]
  attr_accessor :build

  # @private
  def initialize(name, path, spec)
    @name = name
    @path = path
    @revision = self.class.revision || 0

    if path == Formulary.core_path(name)
      @tap = CoreFormulaRepository.instance
      @full_name = name
    elsif path.to_s =~ HOMEBREW_TAP_PATH_REGEX
      @tap = Tap.fetch($1, $2)
      @full_name = "#{@tap}/#{name}"
    else
      @tap = nil
      @full_name = name
    end

    set_spec :stable
    set_spec :devel
    set_spec :head

    @active_spec = determine_active_spec(spec)
    @active_spec_sym = if head?
      :head
    elsif devel?
      :devel
    else
      :stable
    end
    validate_attributes!
    @build = active_spec.build
    @pin = FormulaPin.new(self)
  end

  # @private
  def set_active_spec(spec_sym)
    spec = send(spec_sym)
    raise FormulaSpecificationError, "#{spec_sym} spec is not available for #{full_name}" unless spec
    @active_spec = spec
    @active_spec_sym = spec_sym
    validate_attributes!
    @build = active_spec.build
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
    spec || raise(FormulaSpecificationError, "formulae require at least a URL")
  end

  def validate_attributes!
    if name.nil? || name.empty? || name =~ /\s/
      raise FormulaValidationError.new(full_name, :name, name)
    end

    url = active_spec.url
    if url.nil? || url.empty? || url =~ /\s/
      raise FormulaValidationError.new(full_name, :url, url)
    end

    val = version.respond_to?(:to_str) ? version.to_str : version
    if val.nil? || val.empty? || val =~ /\s/
      raise FormulaValidationError.new(full_name, :version, val)
    end
  end

  public

  # Is the currently active {SoftwareSpec} a {#stable} build?
  # @private
  def stable?
    active_spec == stable
  end

  # Is the currently active {SoftwareSpec} a {#devel} build?
  # @private
  def devel?
    active_spec == devel
  end

  # Is the currently active {SoftwareSpec} a {#head} build?
  # @private
  def head?
    active_spec == head
  end

  # @private
  def bottle_unneeded?
    active_spec.bottle_unneeded?
  end

  # @private
  def bottle_disabled?
    active_spec.bottle_disabled?
  end

  # @private
  def bottle_disable_reason
    active_spec.bottle_disable_reason
  end

  # Does the currently active {SoftwareSpec} has any bottle?
  # @private
  def bottle_defined?
    active_spec.bottle_defined?
  end

  # Does the currently active {SoftwareSpec} has an installable bottle?
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

  # The {PkgVersion} for this formula with {version} and {#revision} information.
  def pkg_version
    PkgVersion.new(version, revision)
  end

  # A named Resource for the currently active {SoftwareSpec}.
  # Additional downloads can be defined as {#resource}s.
  # {Resource#stage} will create a temporary directory and yield to a block.
  # <pre>resource("additional_files").stage { bin.install "my/extra/tool" }</pre>
  def resource(name)
    active_spec.resource(name)
  end

  # An old name for the formula
  def oldname
    @oldname ||= if tap
      formula_renames = tap.formula_renames
      if formula_renames.value?(name)
        formula_renames.to_a.rassoc(name).first
      end
    end
  end

  # All of aliases for the formula
  def aliases
    @aliases ||= if tap
      tap.alias_reverse_table[full_name] || []
    else
      []
    end
  end

  # The {Resource}s for the currently active {SoftwareSpec}.
  def resources
    active_spec.resources.values
  end

  # The {Dependency}s for the currently active {SoftwareSpec}.
  # @private
  def deps
    active_spec.deps
  end

  # The {Requirement}s for the currently active {SoftwareSpec}.
  # @private
  def requirements
    active_spec.requirements
  end

  # The cached download for the currently active {SoftwareSpec}.
  # @private
  def cached_download
    active_spec.cached_download
  end

  # Deletes the download for the currently active {SoftwareSpec}.
  # @private
  def clear_cache
    active_spec.clear_cache
  end

  # The list of patches for the currently active {SoftwareSpec}.
  # @private
  def patchlist
    active_spec.patches
  end

  # The options for the currently active {SoftwareSpec}.
  # @private
  def options
    active_spec.options
  end

  # The deprecated options for the currently active {SoftwareSpec}.
  # @private
  def deprecated_options
    active_spec.deprecated_options
  end

  # The deprecated option flags for the currently active {SoftwareSpec}.
  # @private
  def deprecated_flags
    active_spec.deprecated_flags
  end

  # If a named option is defined for the currently active {SoftwareSpec}.
  def option_defined?(name)
    active_spec.option_defined?(name)
  end

  # All the {.fails_with} for the currently active {SoftwareSpec}.
  # @private
  def compiler_failures
    active_spec.compiler_failures
  end

  # If this {Formula} is installed.
  # This is actually just a check for if the {#installed_prefix} directory
  # exists and is not empty.
  # @private
  def installed?
    (dir = installed_prefix).directory? && dir.children.length > 0
  end

  # If at least one version of {Formula} is installed.
  # @private
  def any_version_installed?
    require "tab"
    installed_prefixes.any? { |keg| (keg/Tab::FILENAME).file? }
  end

  # @private
  # The `LinkedKegs` directory for this {Formula}.
  # You probably want {#opt_prefix} instead.
  def linked_keg
    Pathname.new("#{HOMEBREW_LIBRARY}/LinkedKegs/#{name}")
  end

  # The latest prefix for this formula. Checks for {#head}, then {#devel}
  # and then {#stable}'s {#prefix}
  # @private
  def installed_prefix
    if head && (head_prefix = prefix(PkgVersion.new(head.version, revision))).directory?
      head_prefix
    elsif devel && (devel_prefix = prefix(PkgVersion.new(devel.version, revision))).directory?
      devel_prefix
    elsif stable && (stable_prefix = prefix(PkgVersion.new(stable.version, revision))).directory?
      stable_prefix
    else
      prefix
    end
  end

  # The currently installed version for this formula. Will raise an exception
  # if the formula is not installed.
  # @private
  def installed_version
    Keg.new(installed_prefix).version
  end

  # The directory in the cellar that the formula is installed to.
  # This directory contains the formula's name and version.
  def prefix(v = pkg_version)
    Pathname.new("#{HOMEBREW_CELLAR}/#{name}/#{v}")
  end

  # The parent of the prefix; the named directory in the cellar containing all
  # installed versions of this software
  # @private
  def rack
    prefix.parent
  end

  # All of current installed prefix directories.
  # @private
  def installed_prefixes
    rack.directory? ? rack.subdirs : []
  end

  # All of current installed kegs.
  # @private
  def installed_kegs
    installed_prefixes.map { |dir| Keg.new(dir) }
  end

  # The directory where the formula's binaries should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  #
  # Need to install into the {.bin} but the makefile doesn't mkdir -p prefix/bin?
  # <pre>bin.mkpath</pre>
  #
  # No `make install` available?
  # <pre>bin.install "binary1"</pre>
  def bin
    prefix+"bin"
  end

  # The directory where the formula's documentation should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def doc
    share+"doc"+name
  end

  # The directory where the formula's headers should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  #
  # No `make install` available?
  # <pre>include.install "example.h"</pre>
  def include
    prefix+"include"
  end

  # The directory where the formula's info files should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def info
    share+"info"
  end

  # The directory where the formula's libraries should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  #
  # No `make install` available?
  # <pre>lib.install "example.dylib"</pre>
  def lib
    prefix+"lib"
  end

  # The directory where the formula's binaries should be installed.
  # This is not symlinked into `HOMEBREW_PREFIX`.
  # It is also commonly used to install files that we do not wish to be
  # symlinked into HOMEBREW_PREFIX from one of the other directories and
  # instead manually create symlinks or wrapper scripts into e.g. {#bin}.
  def libexec
    prefix+"libexec"
  end

  # The root directory where the formula's manual pages should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  # Often one of the more specific `man` functions should be used instead
  # e.g. {#man1}
  def man
    share+"man"
  end

  # The directory where the formula's man1 pages should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  #
  # No `make install` available?
  # <pre>man1.install "example.1"</pre>
  def man1
    man+"man1"
  end

  # The directory where the formula's man2 pages should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def man2
    man+"man2"
  end

  # The directory where the formula's man3 pages should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  #
  # No `make install` available?
  # <pre>man3.install "man.3"</pre>
  def man3
    man+"man3"
  end

  # The directory where the formula's man4 pages should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def man4
    man+"man4"
  end

  # The directory where the formula's man5 pages should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def man5
    man+"man5"
  end

  # The directory where the formula's man6 pages should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def man6
    man+"man6"
  end

  # The directory where the formula's man7 pages should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def man7
    man+"man7"
  end

  # The directory where the formula's man8 pages should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def man8
    man+"man8"
  end

  # The directory where the formula's `sbin` binaries should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  # Generally we try to migrate these to {#bin} instead.
  def sbin
    prefix+"sbin"
  end

  # The directory where the formula's shared files should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  #
  # Need a custom directory?
  # <pre>(share/"concept").mkpath</pre>
  #
  # Installing something into another custom directory?
  # <pre>(share/"concept2").install "ducks.txt"</pre>
  #
  # Install `./example_code/simple/ones` to share/demos
  # <pre>(share/"demos").install "example_code/simple/ones"</pre>
  #
  # Install `./example_code/simple/ones` to share/demos/examples
  # <pre>(share/"demos").install "example_code/simple/ones" => "examples"</pre>
  def share
    prefix+"share"
  end

  # The directory where the formula's shared files should be installed,
  # with the name of the formula appended to avoid linking conflicts.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  #
  # No `make install` available?
  # <pre>pkgshare.install "examples"</pre>
  def pkgshare
    prefix+"share"+name
  end

  # The directory where Emacs Lisp files should be installed, with the
  # formula name appended to avoid linking conflicts.
  #
  # Install an Emacs mode included with a software package:
  # <pre>elisp.install "contrib/emacs/example-mode.el"</pre>
  def elisp
    prefix+"share/emacs/site-lisp"+name
  end

  # The directory where the formula's Frameworks should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  # This is not symlinked into `HOMEBREW_PREFIX`.
  def frameworks
    prefix+"Frameworks"
  end

  # The directory where the formula's kernel extensions should be installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  # This is not symlinked into `HOMEBREW_PREFIX`.
  def kext_prefix
    prefix+"Library/Extensions"
  end

  # The directory where the formula's configuration files should be installed.
  # Anything using `etc.install` will not overwrite other files on e.g. upgrades
  # but will write a new file named `*.default`.
  # This directory is not inside the `HOMEBREW_CELLAR` so it is persisted
  # across upgrades.
  def etc
    (HOMEBREW_PREFIX+"etc").extend(InstallRenamed)
  end

  # The directory where the formula's variable files should be installed.
  # This directory is not inside the `HOMEBREW_CELLAR` so it is persisted
  # across upgrades.
  def var
    HOMEBREW_PREFIX+"var"
  end

  # The directory where the formula's Bash completion files should be
  # installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def bash_completion
    prefix+"etc/bash_completion.d"
  end

  # The directory where the formula's ZSH completion files should be
  # installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def zsh_completion
    share+"zsh/site-functions"
  end

  # The directory where the formula's fish completion files should be
  # installed.
  # This is symlinked into `HOMEBREW_PREFIX` after installation or with
  # `brew link` for formulae that are not keg-only.
  def fish_completion
    share+"fish/vendor_completions.d"
  end

  # The directory used for as the prefix for {#etc} and {#var} files on
  # installation so, despite not being in `HOMEBREW_CELLAR`, they are installed
  # there after pouring a bottle.
  # @private
  def bottle_prefix
    prefix+".bottle"
  end

  # The directory where the formula's installation logs will be written.
  # @private
  def logs
    HOMEBREW_LOGS+name
  end

  # This method can be overridden to provide a plist.
  # For more examples read Apple's handy manpage:
  # https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man5/plist.5.html
  # <pre>def plist; <<-EOS.undent
  #  <?xml version="1.0" encoding="UTF-8"?>
  #  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  #  <plist version="1.0">
  #  <dict>
  #    <key>Label</key>
  #      <string>#{plist_name}</string>
  #    <key>ProgramArguments</key>
  #    <array>
  #      <string>#{opt_bin}/example</string>
  #      <string>--do-this</string>
  #    </array>
  #    <key>RunAtLoad</key>
  #    <true/>
  #    <key>KeepAlive</key>
  #    <true/>
  #    <key>StandardErrorPath</key>
  #    <string>/dev/null</string>
  #    <key>StandardOutPath</key>
  #    <string>/dev/null</string>
  #  </plist>
  #  EOS
  #end</pre>
  def plist
    nil
  end
  alias_method :startup_plist, :plist

  # The generated launchd {.plist} service name.
  def plist_name
    "homebrew.mxcl."+name
  end

  # The generated launchd {.plist} file path.
  def plist_path
    prefix+(plist_name+".plist")
  end

  # @private
  def plist_manual
    self.class.plist_manual
  end

  # @private
  def plist_startup
    self.class.plist_startup
  end

  # A stable path for this formula, when installed. Contains the formula name
  # but no version number. Only the active version will be linked here if
  # multiple versions are installed.
  #
  # This is the prefered way to refer a formula in plists or from another
  # formula, as the path is stable even when the software is updated.
  # <pre>args << "--with-readline=#{Formula["readline"].opt_prefix}" if build.with? "readline"</pre>
  def opt_prefix
    Pathname.new("#{HOMEBREW_PREFIX}/opt/#{name}")
  end

  def opt_bin
    opt_prefix+"bin"
  end

  def opt_include
    opt_prefix+"include"
  end

  def opt_lib
    opt_prefix+"lib"
  end

  def opt_libexec
    opt_prefix+"libexec"
  end

  def opt_sbin
    opt_prefix+"sbin"
  end

  def opt_share
    opt_prefix+"share"
  end

  def opt_pkgshare
    opt_prefix+"share"+name
  end

  def opt_elisp
    opt_prefix+"share/emacs/site-lisp"+name
  end

  def opt_frameworks
    opt_prefix+"Frameworks"
  end

  # Can be overridden to selectively disable bottles from formulae.
  # Defaults to true so overridden version does not have to check if bottles
  # are supported.
  # Replaced by {.pour_bottle}'s `satisfy` method if it is specified.
  def pour_bottle?
    true
  end

  # @private
  def pour_bottle_check_unsatisfied_reason
    self.class.pour_bottle_check_unsatisfied_reason
  end

  # Can be overridden to run commands on both source and bottle installation.
  def post_install; end

  # @private
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

  # Tell the user about any caveats regarding this package.
  # @return [String]
  # <pre>def caveats
  #   <<-EOS.undent
  #     Are optional. Something the user should know?
  #   EOS
  # end</pre>
  #
  # <pre>def caveats
  #   s = <<-EOS.undent
  #     Print some important notice to the user when `brew info <formula>` is
  #     called or when brewing a formula.
  #     This is optional. You can use all the vars like #{version} here.
  #   EOS
  #   s += "Some issue only on older systems" if MacOS.version < :mountain_lion
  #   s
  # end</pre>
  def caveats
    nil
  end

  # rarely, you don't want your library symlinked into the main prefix
  # see gettext.rb for an example
  def keg_only?
    keg_only_reason && keg_only_reason.valid?
  end

  # @private
  def keg_only_reason
    self.class.keg_only_reason
  end

  # sometimes the formula cleaner breaks things
  # skip cleaning paths in a formula with a class method like this:
  #   skip_clean "bin/foo", "lib/bar"
  # keep .la files with:
  #   skip_clean :la
  # @private
  def skip_clean?(path)
    return true if path.extname == ".la" && self.class.skip_clean_paths.include?(:la)
    to_check = path.relative_path_from(prefix).to_s
    self.class.skip_clean_paths.include? to_check
  end

  # Sometimes we accidentally install files outside prefix. After we fix that,
  # users will get nasty link conflict error. So we create a whitelist here to
  # allow overwriting certain files. e.g.
  #   link_overwrite "bin/foo", "lib/bar"
  #   link_overwrite "share/man/man1/baz-*"
  # @private
  def link_overwrite?(path)
    # Don't overwrite files not created by Homebrew.
    return false unless path.stat.uid == HOMEBREW_BREW_FILE.stat.uid
    # Don't overwrite files belong to other keg except when that
    # keg's formula is deleted.
    begin
      keg = Keg.for(path)
    rescue NotAKegError, Errno::ENOENT
      # file doesn't belong to any keg.
    else
      tab_tap = Tab.for_keg(keg).tap
      return false if tab_tap.nil? # this keg doesn't below to any core/tap formula, most likely coming from a DIY install.
      begin
        Formulary.factory(keg.name)
      rescue FormulaUnavailableError
        # formula for this keg is deleted, so defer to whitelist
      rescue TapFormulaAmbiguityError, TapFormulaWithOldnameAmbiguityError
        return false # this keg belongs to another formula
      else
        return false # this keg belongs to another formula
      end
    end
    to_check = path.relative_path_from(HOMEBREW_PREFIX).to_s
    self.class.link_overwrite_paths.any? do |p|
      p == to_check ||
        to_check.start_with?(p.chomp("/") + "/") ||
        /^#{Regexp.escape(p).gsub('\*', ".*?")}$/ === to_check
    end
  end

  def skip_cxxstdlib_check?
    false
  end

  # @private
  def require_universal_deps?
    false
  end

  # @private
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

  # @private
  def lock
    @lock = FormulaLock.new(name)
    @lock.lock
    if oldname && (oldname_rack = HOMEBREW_CELLAR/oldname).exist? && oldname_rack.resolved_path == rack
      @oldname_lock = FormulaLock.new(oldname)
      @oldname_lock.lock
    end
  end

  # @private
  def unlock
    @lock.unlock unless @lock.nil?
    @oldname_lock.unlock unless @oldname_lock.nil?
  end

  # @private
  def outdated_versions
    @outdated_versions ||= begin
      all_versions = []
      older_or_same_tap_versions = []

      if oldname && !rack.exist? && (dir = HOMEBREW_CELLAR/oldname).directory? &&
        !dir.subdirs.empty? && tap == Tab.for_keg(dir.subdirs.first).tap
        raise Migrator::MigrationNeededError.new(self)
      end

      installed_kegs.each do |keg|
        version = keg.version
        all_versions << version
        older_version = pkg_version <= version

        tab_tap = Tab.for_keg(keg).tap
        if tab_tap.nil? || tab_tap == tap || older_version
          older_or_same_tap_versions << version
        end
      end

      if older_or_same_tap_versions.all? { |v| pkg_version > v }
        all_versions.sort!
      else
        []
      end
    end
  end

  # @private
  def outdated?
    outdated_versions.any?
  rescue Migrator::MigrationNeededError
    true
  end

  # @private
  def pinnable?
    @pin.pinnable?
  end

  # @private
  def pinned?
    @pin.pinned?
  end

  # @private
  def pinned_version
    @pin.pinned_version
  end

  # @private
  def pin
    @pin.pin
  end

  # @private
  def unpin
    @pin.unpin
  end

  # @private
  def ==(other)
    instance_of?(other.class) &&
      name == other.name &&
      active_spec == other.active_spec
  end
  alias_method :eql?, :==

  # @private
  def hash
    name.hash
  end

  # @private
  def <=>(other)
    return unless Formula === other
    name <=> other.name
  end

  def to_s
    name
  end

  # @private
  def inspect
    "#<Formula #{name} (#{active_spec_sym}) #{path}>"
  end

  # Standard parameters for CMake builds.
  # Setting CMAKE_FIND_FRAMEWORK to "LAST" tells CMake to search for our
  # libraries before trying to utilize Frameworks, many of which will be from
  # 3rd party installs.
  # Note: there isn't a std_autotools variant because autotools is a lot
  # less consistent and the standard parameters are more memorable.
  def std_cmake_args
    %W[
      -DCMAKE_C_FLAGS_RELEASE=-DNDEBUG
      -DCMAKE_CXX_FLAGS_RELEASE=-DNDEBUG
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_FIND_FRAMEWORK=LAST
      -DCMAKE_VERBOSE_MAKEFILE=ON
      -Wno-dev
    ]
  end

  # an array of all core {Formula} names
  # @private
  def self.core_names
    CoreFormulaRepository.instance.formula_names
  end

  # an array of all core {Formula} files
  # @private
  def self.core_files
    CoreFormulaRepository.instance.formula_files
  end

  # an array of all tap {Formula} names
  # @private
  def self.tap_names
    @tap_names ||= Tap.reject(&:core_formula_repository?).flat_map(&:formula_names).sort
  end

  # an array of all tap {Formula} files
  # @private
  def self.tap_files
    @tap_files ||= Tap.reject(&:core_formula_repository?).flat_map(&:formula_files)
  end

  # an array of all {Formula} names
  # @private
  def self.names
    @names ||= (core_names + tap_names.map { |name| name.split("/")[-1] }).uniq.sort
  end

  # an array of all {Formula} files
  # @private
  def self.files
    @files ||= core_files + tap_files
  end

  # an array of all {Formula} names, which the tap formulae have the fully-qualified name
  # @private
  def self.full_names
    @full_names ||= core_names + tap_names
  end

  # @private
  def self.each
    files.each do |file|
      begin
        yield Formulary.factory(file)
      rescue StandardError => e
        # Don't let one broken formula break commands. But do complain.
        onoe "Failed to import: #{file}"
        puts e
        next
      end
    end
  end

  # An array of all racks currently installed.
  # @private
  def self.racks
    @racks ||= if HOMEBREW_CELLAR.directory?
      HOMEBREW_CELLAR.subdirs.reject do |rack|
        rack.symlink? || rack.subdirs.empty?
      end
    else
      []
    end
  end

  # An array of all installed {Formula}
  # @private
  def self.installed
    @installed ||= racks.map do |rack|
      begin
        Formulary.from_rack(rack)
      rescue FormulaUnavailableError, TapFormulaAmbiguityError, TapFormulaWithOldnameAmbiguityError
      end
    end.compact
  end

  # an array of all alias files of core {Formula}
  # @private
  def self.core_alias_files
    CoreFormulaRepository.instance.alias_files
  end

  # an array of all core aliases
  # @private
  def self.core_aliases
    CoreFormulaRepository.instance.aliases
  end

  # an array of all tap aliases
  # @private
  def self.tap_aliases
    @tap_aliases ||= Tap.reject(&:core_formula_repository?).flat_map(&:aliases).sort
  end

  # an array of all aliases
  # @private
  def self.aliases
    @aliases ||= (core_aliases + tap_aliases.map { |name| name.split("/")[-1] }).uniq.sort
  end

  # an array of all aliases, , which the tap formulae have the fully-qualified name
  # @private
  def self.alias_full_names
    @alias_full_names ||= core_aliases + tap_aliases
  end

  # a table mapping core alias to formula name
  # @private
  def self.core_alias_table
    CoreFormulaRepository.instance.alias_table
  end

  # a table mapping core formula name to aliases
  # @private
  def self.core_alias_reverse_table
    CoreFormulaRepository.instance.alias_reverse_table
  end

  def self.[](name)
    Formulary.factory(name)
  end

  # True if this formula is provided by Homebrew itself
  # @private
  def core_formula?
    tap && tap.core_formula_repository?
  end

  # True if this formula is provided by external Tap
  # @private
  def tap?
    tap && !tap.core_formula_repository?
  end

  # @private
  def print_tap_action(options = {})
    if tap?
      verb = options[:verb] || "Installing"
      ohai "#{verb} #{name} from #{tap}"
    end
  end

  # @private
  def env
    self.class.env
  end

  # @private
  def conflicts
    self.class.conflicts
  end

  # Returns a list of Dependency objects in an installable order, which
  # means if a depends on b then b will be ordered before a in this list
  # @private
  def recursive_dependencies(&block)
    Dependency.expand(self, &block)
  end

  # The full set of Requirements for this formula's dependency tree.
  # @private
  def recursive_requirements(&block)
    Requirement.expand(self, &block)
  end

  # @private
  def to_hash
    hsh = {
      "name" => name,
      "full_name" => full_name,
      "desc" => desc,
      "homepage" => homepage,
      "oldname" => oldname,
      "aliases" => aliases,
      "versions" => {
        "stable" => (stable.version.to_s if stable),
        "bottle" => bottle ? true : false,
        "devel" => (devel.version.to_s if devel),
        "head" => (head.version.to_s if head)
      },
      "revision" => revision,
      "installed" => [],
      "linked_keg" => (linked_keg.resolved_path.basename.to_s if linked_keg.exist?),
      "pinned" => pinned?,
      "outdated" => outdated?,
      "keg_only" => keg_only?,
      "dependencies" => deps.map(&:name).uniq,
      "recommended_dependencies" => deps.select(&:recommended?).map(&:name).uniq,
      "optional_dependencies" => deps.select(&:optional?).map(&:name).uniq,
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

    hsh["options"] = options.map do |opt|
      { "option" => opt.flag, "description" => opt.description }
    end

    hsh["bottle"] = {}
    %w[stable devel].each do |spec_sym|
      next unless spec = send(spec_sym)
      next unless spec.bottle_defined?
      bottle_spec = spec.bottle_specification
      bottle_info = {
        "revision" => bottle_spec.revision,
        "cellar" => (cellar = bottle_spec.cellar).is_a?(Symbol) ? \
                    cellar.inspect : cellar,
        "prefix" => bottle_spec.prefix,
        "root_url" => bottle_spec.root_url,
      }
      bottle_info["files"] = {}
      bottle_spec.collector.keys.each do |os|
        checksum = bottle_spec.collector[os]
        bottle_info["files"][os] = {
          "url" => "#{bottle_spec.root_url}/#{Bottle::Filename.create(self, os, bottle_spec.revision)}",
          checksum.hash_type.to_s => checksum.hexdigest,
        }
      end
      hsh["bottle"][spec_sym] = bottle_info
    end

    installed_kegs.each do |keg|
      tab = Tab.for_keg keg

      hsh["installed"] << {
        "version" => keg.version.to_s,
        "used_options" => tab.used_options.as_flags,
        "built_as_bottle" => tab.built_as_bottle,
        "poured_from_bottle" => tab.poured_from_bottle
      }
    end

    hsh["installed"] = hsh["installed"].sort_by { |i| Version.new(i["version"]) }

    hsh
  end

  # @private
  def fetch
    active_spec.fetch
  end

  # @private
  def verify_download_integrity(fn)
    active_spec.verify_download_integrity(fn)
  end

  # @private
  def run_test
    old_home = ENV["HOME"]
    build, self.build = self.build, Tab.for_formula(self)
    mktemp do
      @testpath = Pathname.pwd
      ENV["HOME"] = @testpath
      setup_home @testpath
      test
    end
  ensure
    @testpath = nil
    self.build = build
    ENV["HOME"] = old_home
  end

  # @private
  def test_defined?
    false
  end

  # @private
  def test
  end

  # @private
  def test_fixtures(file)
    HOMEBREW_LIBRARY.join("Homebrew", "test", "fixtures", file)
  end

  # This method is overriden in {Formula} subclasses to provide the installation instructions.
  # The sources (from {.url}) are downloaded, hash-checked and
  # Homebrew changes into a temporary directory where the
  # archive was unpacked or repository cloned.
  # <pre>def install
  #   system "./configure", "--prefix=#{prefix}"
  #   system "make", "install"
  # end</pre>
  def install
  end

  protected

  def setup_home(home)
    # keep Homebrew's site-packages in sys.path when using system Python
    user_site_packages = home/"Library/Python/2.7/lib/python/site-packages"
    user_site_packages.mkpath
    (user_site_packages/"homebrew.pth").write <<-EOS.undent
      import site; site.addsitedir("#{HOMEBREW_PREFIX}/lib/python2.7/site-packages")
      import sys, os; sys.path = (os.environ["PYTHONPATH"].split(os.pathsep) if "PYTHONPATH" in os.environ else []) + ["#{HOMEBREW_PREFIX}/lib/python2.7/site-packages"] + sys.path
    EOS
  end

  public

  # To call out to the system, we use the `system` method and we prefer
  # you give the args separately as in the line below, otherwise a subshell
  # has to be opened first.
  # <pre>system "./bootstrap.sh", "--arg1", "--prefix=#{prefix}"</pre>
  #
  # For CMake we have some necessary defaults in {#std_cmake_args}:
  # <pre>system "cmake", ".", *std_cmake_args</pre>
  #
  # If the arguments given to configure (or make or cmake) are depending
  # on options defined above, we usually make a list first and then
  # use the `args << if <condition>` to append to:
  # <pre>args = ["--with-option1", "--with-option2"]
  #
  # # Most software still uses `configure` and `make`.
  # # Check with `./configure --help` what our options are.
  # system "./configure", "--disable-debug", "--disable-dependency-tracking",
  #                       "--disable-silent-rules", "--prefix=#{prefix}",
  #                       *args # our custom arg list (needs `*` to unpack)
  #
  # # If there is a "make", "install" available, please use it!
  # system "make", "install"</pre>
  def system(cmd, *args)
    verbose = ARGV.verbose?
    verbose_using_dots = !ENV["HOMEBREW_VERBOSE_USING_DOTS"].nil?

    # remove "boring" arguments so that the important ones are more likely to
    # be shown considering that we trim long ohai lines to the terminal width
    pretty_args = args.dup
    if cmd == "./configure" && !verbose
      pretty_args.delete "--disable-dependency-tracking"
      pretty_args.delete "--disable-debug"
    end
    pretty_args.each_index do |i|
      if pretty_args[i].to_s.start_with? "import setuptools"
        pretty_args[i] = "import setuptools..."
      end
    end
    ohai "#{cmd} #{pretty_args*" "}".strip

    @exec_count ||= 0
    @exec_count += 1
    logfn = "#{logs}/%02d.%s" % [@exec_count, File.basename(cmd).split(" ").first]
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

          if verbose_using_dots
            last_dot = Time.at(0)
            while buf = rd.gets
              log.puts buf
              # make sure dots printed with interval of at least 1 min.
              if (Time.now - last_dot) > 60
                print "."
                $stdout.flush
                last_dot = Time.now
              end
            end
            puts
          else
            while buf = rd.gets
              log.puts buf
              puts buf
            end
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
        log_lines = ENV["HOMEBREW_FAIL_LOG_LINES"]
        log_lines ||= "15"

        log.flush
        if !verbose || verbose_using_dots
          puts "Last #{log_lines} lines from #{logfn}:"
          Kernel.system "/usr/bin/tail", "-n", log_lines, logfn
        end
        log.puts

        require "cmd/config"
        require "build_environment"

        env = ENV.to_hash

        Homebrew.dump_verbose_config(log)
        log.puts
        Homebrew.dump_build_env(env, log)

        raise BuildError.new(self, cmd, args, env)
      end
    end
  end

  # @private
  def eligible_kegs_for_cleanup
    eligible_for_cleanup = []
    if installed?
      eligible_kegs = installed_kegs.select { |k| pkg_version > k.version }
      if eligible_kegs.any?
        eligible_kegs.each do |keg|
          if keg.linked?
            opoo "Skipping (old) #{keg} due to it being linked"
          else
            eligible_for_cleanup << keg
          end
        end
      end
    elsif installed_prefixes.any? && !pinned?
      # If the cellar only has one version installed, don't complain
      # that we can't tell which one to keep. Don't complain at all if the
      # only installed version is a pinned formula.
      opoo "Skipping #{full_name}: most recent version #{pkg_version} not installed"
    end
    eligible_for_cleanup
  end

  private

  def exec_cmd(cmd, args, out, logfn)
    ENV["HOMEBREW_CC_LOG_PATH"] = logfn

    # TODO: system "xcodebuild" is deprecated, this should be removed soon.
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
    args.collect!(&:to_s)
    exec(cmd, *args) rescue nil
    puts "Failed to execute: #{cmd}"
    exit! 1 # never gets here unless exec threw or failed
  end

  def stage
    active_spec.stage do
      @source_modified_time = active_spec.source_modified_time
      @buildpath = Pathname.pwd
      env_home = buildpath/".brew_home"
      mkdir_p env_home

      old_home, ENV["HOME"] = ENV["HOME"], env_home
      setup_home env_home

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

    patchlist.each do |patch|
      patch.verify_download_integrity(patch.fetch) if patch.external?
    end
  end

  def self.method_added(method)
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
    #
    # <pre>desc "Example formula"</pre>
    attr_rw :desc

    # @!attribute [w] homepage
    # The homepage for the software. Used by users to get more information
    # about the software and Homebrew maintainers as a point of contact for
    # e.g. submitting patches.
    # Can be opened with running `brew home`.
    #
    # <pre>homepage "https://www.example.com"</pre>
    attr_rw :homepage

    # The `:startup` attribute set by {.plist_options}.
    # @private
    attr_reader :plist_startup

    # The `:manual` attribute set by {.plist_options}.
    # @private
    attr_reader :plist_manual

    # If `pour_bottle?` returns `false` the user-visible reason to display for
    # why they cannot use the bottle.
    # @private
    attr_accessor :pour_bottle_check_unsatisfied_reason

    # @!attribute [w] revision
    # Used for creating new Homebrew versions of software without new upstream
    # versions. For example, if we bump the major version of a library this
    # {Formula} {.depends_on} then we may need to update the `revision` of this
    # {Formula} to install a new version linked against the new library version.
    # `0` if unset.
    #
    # <pre>revision 1</pre>
    attr_rw :revision

    # A list of the {.stable}, {.devel} and {.head} {SoftwareSpec}s.
    # @private
    def specs
      @specs ||= [stable, devel, head].freeze
    end

    # @!attribute [w] url
    # The URL used to download the source for the {#stable} version of the formula.
    # We prefer `https` for security and proxy reasons.
    # Optionally specify the download strategy with `:using => ...`
    #     `:git`, `:hg`, `:svn`, `:bzr`, `:cvs`,
    #     `:curl` (normal file download. Will also extract.)
    #     `:nounzip` (without extracting)
    #     `:post` (download via an HTTP POST)
    #     `S3DownloadStrategy` (download from S3 using signed request)
    #
    # <pre>url "https://packed.sources.and.we.prefer.https.example.com/archive-1.2.3.tar.bz2"</pre>
    # <pre>url "https://some.dont.provide.archives.example.com", :using => :git, :tag => "1.2.3", :revision => "db8e4de5b2d6653f66aea53094624468caad15d2"</pre>
    def url(val, specs = {})
      stable.url(val, specs)
    end

    # @!attribute [w] version
    # The version string for the {#stable} version of the formula.
    # The version is autodetected from the URL and/or tag so only needs to be
    # declared if it cannot be autodetected correctly.
    #
    # <pre>version "1.2-final"</pre>
    def version(val = nil)
      stable.version(val)
    end

    # @!attribute [w] mirror
    # Additional URLs for the {#stable} version of the formula.
    # These are only used if the {.url} fails to download. It's optional and
    # there can be more than one. Generally we add them when the main {.url}
    # is unreliable. If {.url} is really unreliable then we may swap the
    # {.mirror} and {.url}.
    #
    # <pre>mirror "https://in.case.the.host.is.down.example.com"
    # mirror "https://in.case.the.mirror.is.down.example.com</pre>
    def mirror(val)
      stable.mirror(val)
    end

    # @!attribute [w] sha256
    # @scope class
    # To verify the {#cached_download}'s integrity and security we verify the
    # SHA-256 hash matches what we've declared in the {Formula}. To quickly fill
    # this value you can leave it blank and run `brew fetch --force` and it'll
    # tell you the currently valid value.
    #
    # <pre>sha256 "2a2ba417eebaadcb4418ee7b12fe2998f26d6e6f7fda7983412ff66a741ab6f7"</pre>
    Checksum::TYPES.each do |type|
      define_method(type) { |val| stable.send(type, val) }
    end

    # @!attribute [w] bottle
    # Adds a {.bottle} {SoftwareSpec}.
    # This provides a pre-built binary package built by the Homebrew maintainers for you.
    # It will be installed automatically if there is a binary package for your platform
    # and you haven't passed or previously used any options on this formula.
    #
    # If you maintain your own repository, you can add your own bottle links.
    # https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Bottles.md
    # You can ignore this block entirely if submitting to Homebrew/Homebrew, It'll be
    # handled for you by the Brew Test Bot.
    #
    # <pre>bottle do
    #   root_url "https://example.com" # Optional root to calculate bottle URLs
    #   prefix "/opt/homebrew" # Optional HOMEBREW_PREFIX in which the bottles were built.
    #   cellar "/opt/homebrew/Cellar" # Optional HOMEBREW_CELLAR in which the bottles were built.
    #   revision 1 # Making the old bottle outdated without bumping the version/revision of the formula.
    #   sha256 "4355a46b19d348dc2f57c046f8ef63d4538ebb936000f3c9ee954a27460dd865" => :el_capitan
    #   sha256 "53c234e5e8472b6ac51c1ae1cab3fe06fad053beb8ebfd8977b010655bfdd3c3" => :yosemite
    #   sha256 "1121cfccd5913f0a63fec40a6ffd44ea64f9dc135c66634ba001d10bcf4302a2" => :mavericks
    # end</pre>
    #
    # Only formulae where the upstream URL breaks or moves frequently, require compile
    # or have a reasonable amount of patches/resources should be bottled.
    # Formulae which do not meet the above requirements should not be bottled.
    #
    # Formulae which should not be bottled & can be installed without any compile
    # required should be tagged with:
    # <pre>bottle :unneeded</pre>
    #
    # Otherwise formulae which do not meet the above requirements and should not
    # be bottled should be tagged with:
    # <pre>bottle :disable, "reasons"</pre>
    def bottle(*args, &block)
      stable.bottle(*args, &block)
    end

    # @private
    def build
      stable.build
    end

    # @!attribute [w] stable
    # Allows adding {.depends_on} and {#patch}es just to the {.stable} {SoftwareSpec}.
    # This is required instead of using a conditional.
    # It is preferrable to also pull the {url} and {.sha256} into the block if one is added.
    #
    # <pre>stable do
    #   url "https://example.com/foo-1.0.tar.gz"
    #   sha256 "2a2ba417eebaadcb4418ee7b12fe2998f26d6e6f7fda7983412ff66a741ab6f7"
    #
    #   depends_on "libxml2"
    #   depends_on "libffi"
    # end</pre>
    def stable(&block)
      @stable ||= SoftwareSpec.new
      return @stable unless block_given?
      @stable.instance_eval(&block)
    end

    # @!attribute [w] devel
    # Adds a {.devel} {SoftwareSpec}.
    # This can be installed by passing the `--devel` option to allow
    # installing non-stable (e.g. beta) versions of software.
    #
    # <pre>devel do
    #   url "https://example.com/archive-2.0-beta.tar.gz"
    #   sha256 "2a2ba417eebaadcb4418ee7b12fe2998f26d6e6f7fda7983412ff66a741ab6f7"
    #
    #   depends_on "cairo"
    #   depends_on "pixman"
    # end</pre>
    def devel(&block)
      @devel ||= SoftwareSpec.new
      return @devel unless block_given?
      @devel.instance_eval(&block)
    end

    # @!attribute [w] head
    # Adds a {.head} {SoftwareSpec}.
    # This can be installed by passing the `--HEAD` option to allow
    # installing software directly from a branch of a version-control repository.
    # If called as a method this provides just the {url} for the {SoftwareSpec}.
    # If a block is provided you can also add {.depends_on} and {#patch}es just to the {.head} {SoftwareSpec}.
    # The download strategies (e.g. `:using =>`) are the same as for {url}.
    # `master` is the default branch and doesn't need stating with a `:branch` parameter.
    # <pre>head "https://we.prefer.https.over.git.example.com/.git"</pre>
    # <pre>head "https://example.com/.git", :branch => "name_of_branch", :revision => "abc123"</pre>
    # or (if autodetect fails):
    # <pre>head "https://hg.is.awesome.but.git.has.won.example.com/", :using => :hg</pre>
    def head(val = nil, specs = {}, &block)
      @head ||= HeadSoftwareSpec.new
      if block_given?
        @head.instance_eval(&block)
      elsif val
        @head.url(val, specs)
      else
        @head
      end
    end

    # Additional downloads can be defined as resources and accessed in the
    # install method. Resources can also be defined inside a stable, devel, or
    # head block. This mechanism replaces ad-hoc "subformula" classes.
    # <pre>resource "additional_files" do
    #   url "https://example.com/additional-stuff.tar.gz"
    #   sha256 "c6bc3f48ce8e797854c4b865f6a8ff969867bbcaebd648ae6fd825683e59fef2"
    # end</pre>
    def resource(name, klass = Resource, &block)
      specs.each do |spec|
        spec.resource(name, klass, &block) unless spec.resource_defined?(name)
      end
    end

    def go_resource(name, &block)
      specs.each { |spec| spec.go_resource(name, &block) }
    end

    # The dependencies for this formula. Use strings for the names of other
    # formulae. Homebrew provides some :special dependencies for stuff that
    # requires certain extra handling (often changing some ENV vars or
    # deciding if to use the system provided version or not.)
    # <pre># `:build` means this dep is only needed during build.
    # depends_on "cmake" => :build</pre>
    # <pre>depends_on "homebrew/dupes/tcl-tk" => :optional</pre>
    # <pre># `:recommended` dependencies are built by default.
    # # But a `--without-...` option is generated to opt-out.
    # depends_on "readline" => :recommended</pre>
    # <pre># `:optional` dependencies are NOT built by default.
    # # But a `--with-...` options is generated.
    # depends_on "glib" => :optional</pre>
    # <pre># If you need to specify that another formula has to be built with/out
    # # certain options (note, no `--` needed before the option):
    # depends_on "zeromq" => "with-pgm"
    # depends_on "qt" => ["with-qtdbus", "developer"] # Multiple options.</pre>
    # <pre># Optional and enforce that boost is built with `--with-c++11`.
    # depends_on "boost" => [:optional, "with-c++11"]</pre>
    # <pre># If a dependency is only needed in certain cases:
    # depends_on "sqlite" if MacOS.version == :leopard
    # depends_on :xcode # If the formula really needs full Xcode.
    # depends_on :tex # Homebrew does not provide a Tex Distribution.
    # depends_on :fortran # Checks that `gfortran` is available or `FC` is set.
    # depends_on :mpi => :cc # Needs MPI with `cc`
    # depends_on :mpi => [:cc, :cxx, :optional] # Is optional. MPI with `cc` and `cxx`.
    # depends_on :macos => :lion # Needs at least Mac OS X "Lion" aka. 10.7.
    # depends_on :apr # If a formula requires the CLT-provided apr library to exist.
    # depends_on :arch => :intel # If this formula only builds on Intel architecture.
    # depends_on :arch => :x86_64 # If this formula only builds on Intel x86 64-bit.
    # depends_on :arch => :ppc # Only builds on PowerPC?
    # depends_on :ld64 # Sometimes ld fails on `MacOS.version < :leopard`. Then use this.
    # depends_on :x11 # X11/XQuartz components. Non-optional X11 deps should go in Homebrew/Homebrew-x11
    # depends_on :osxfuse # Permits the use of the upstream signed binary or our source package.
    # depends_on :tuntap # Does the same thing as above. This is vital for Yosemite and above.
    # depends_on :mysql => :recommended</pre>
    # <pre># It is possible to only depend on something if
    # # `build.with?` or `build.without? "another_formula"`:
    # depends_on :mysql # allows brewed or external mysql to be used
    # depends_on :postgresql if build.without? "sqlite"
    # depends_on :hg # Mercurial (external or brewed) is needed</pre>
    #
    # <pre># If any Python >= 2.7 < 3.x is okay (either from OS X or brewed):
    # depends_on :python</pre>
    # <pre># to depend on Python >= 2.7 but use system Python where possible
    # depends_on :python if MacOS.version <= :snow_leopard</pre>
    # <pre># Python 3.x if the `--with-python3` is given to `brew install example`
    # depends_on :python3 => :optional</pre>
    def depends_on(dep)
      specs.each { |spec| spec.depends_on(dep) }
    end

    # @!attribute [w] option
    # Options can be used as arguments to `brew install`.
    # To switch features on/off: `"with-something"` or `"with-otherthing"`.
    # To use other software: `"with-other-software"` or `"without-foo"`
    # Note, that for {.depends_on} that are `:optional` or `:recommended`, options
    # are generated automatically.
    #
    # There are also some special options:
    # - `:universal`: build a universal binary/library (e.g. on newer Intel Macs
    #   this means a combined x86_64/x86 binary/library).
    # <pre>option "with-spam", "The description goes here without a dot at the end"</pre>
    # <pre>option "with-qt", "Text here overwrites the autogenerated one from 'depends_on "qt" => :optional'"</pre>
    # <pre>option :universal</pre>
    def option(name, description = "")
      specs.each { |spec| spec.option(name, description) }
    end

    # @!attribute [w] deprecated_option
    # Deprecated options are used to rename options and migrate users who used
    # them to newer ones. They are mostly used for migrating non-`with` options
    # (e.g. `enable-debug`) to `with` options (e.g. `with-debug`).
    # <pre>deprecated_option "enable-debug" => "with-debug"</pre>
    def deprecated_option(hash)
      specs.each { |spec| spec.deprecated_option(hash) }
    end

    # External patches can be declared using resource-style blocks.
    # <pre>patch do
    #   url "https://example.com/example_patch.diff"
    #   sha256 "c6bc3f48ce8e797854c4b865f6a8ff969867bbcaebd648ae6fd825683e59fef2"
    # end</pre>
    #
    # A strip level of `-p1` is assumed. It can be overridden using a symbol
    # argument:
    # <pre>patch :p0 do
    #   url "https://example.com/example_patch.diff"
    #   sha256 "c6bc3f48ce8e797854c4b865f6a8ff969867bbcaebd648ae6fd825683e59fef2"
    # end</pre>
    #
    # Patches can be declared in stable, devel, and head blocks. This form is
    # preferred over using conditionals.
    # <pre>stable do
    #   patch do
    #     url "https://example.com/example_patch.diff"
    #     sha256 "c6bc3f48ce8e797854c4b865f6a8ff969867bbcaebd648ae6fd825683e59fef2"
    #   end
    # end</pre>
    #
    # Embedded (`__END__`) patches are declared like so:
    # <pre>patch :DATA
    # patch :p0, :DATA</pre>
    #
    # Patches can also be embedded by passing a string. This makes it possible
    # to provide multiple embedded patches while making only some of them
    # conditional.
    # <pre>patch :p0, "..."</pre>
    def patch(strip = :p1, src = nil, &block)
      specs.each { |spec| spec.patch(strip, src, &block) }
    end

    # Defines launchd plist handling.
    #
    # Does your plist need to be loaded at startup?
    # <pre>plist_options :startup => true</pre>
    #
    # Or only when necessary or desired by the user?
    # <pre>plist_options :manual => "foo"</pre>
    #
    # Or perhaps you'd like to give the user a choice? Ooh fancy.
    # <pre>plist_options :startup => "true", :manual => "foo start"</pre>
    def plist_options(options)
      @plist_startup = options[:startup]
      @plist_manual = options[:manual]
    end

    # @private
    def conflicts
      @conflicts ||= []
    end

    # If this formula conflicts with another one.
    # <pre>conflicts_with "imagemagick", :because => "because this is just a stupid example"</pre>
    def conflicts_with(*names)
      opts = Hash === names.last ? names.pop : {}
      names.each { |name| conflicts << FormulaConflict.new(name, opts[:because]) }
    end

    def skip_clean(*paths)
      paths.flatten!
      # Specifying :all is deprecated and will become an error
      skip_clean_paths.merge(paths)
    end

    # @private
    def skip_clean_paths
      @skip_clean_paths ||= Set.new
    end

    # Software that will not be sym-linked into the `brew --prefix` will only
    # live in its Cellar. Other formulae can depend on it and then brew will
    # add the necessary includes and libs (etc.) during the brewing of that
    # other formula. But generally, keg_only formulae are not in your PATH
    # and not seen by compilers if you build your own software outside of
    # Homebrew. This way, we don't shadow software provided by OS X.
    # <pre>keg_only :provided_by_osx</pre>
    # <pre>keg_only "because I want it so"</pre>
    def keg_only(reason, explanation = "")
      @keg_only_reason = KegOnlyReason.new(reason, explanation)
    end

    # Pass :skip to this method to disable post-install stdlib checking
    def cxxstdlib_check(check_type)
      define_method(:skip_cxxstdlib_check?) { true } if check_type == :skip
    end

    # Marks the {Formula} as failing with a particular compiler so it will fall back to others.
    # For Apple compilers, this should be in the format:
    # <pre>fails_with :llvm do # :llvm is really llvm-gcc
    #   build 2334
    #   cause "Segmentation fault during linking."
    # end
    #
    # fails_with :clang do
    #   build 600
    #   cause "multiple configure and compile errors"
    # end</pre>
    #
    # The block may be omitted, and if present the build may be omitted;
    # if so, then the compiler will be blacklisted for *all* versions.
    #
    # `major_version` should be the major release number only, for instance
    # '4.8' for the GCC 4.8 series (4.8.0, 4.8.1, etc.).
    # If `version` or the block is omitted, then the compiler will be
    # blacklisted for all compilers in that series.
    #
    # For example, if a bug is only triggered on GCC 4.8.1 but is not
    # encountered on 4.8.2:
    #
    # <pre>fails_with :gcc => '4.8' do
    #   version '4.8.1'
    # end</pre>
    def fails_with(compiler, &block)
      specs.each { |spec| spec.fails_with(compiler, &block) }
    end

    def needs(*standards)
      specs.each { |spec| spec.needs(*standards) }
    end

    # Test (is required for new formula and makes us happy).
    # @return [Boolean]
    #
    # The block will create, run in and delete a temporary directory.
    #
    # We are fine if the executable does not error out, so we know linking
    # and building the software was ok.
    # <pre>system bin/"foobar", "--version"</pre>
    #
    # <pre>(testpath/"test.file").write <<-EOS.undent
    #   writing some test file, if you need to
    # EOS
    # assert_equal "OK", shell_output("test_command test.file").strip</pre>
    #
    # Need complete control over stdin, stdout?
    # <pre>require "open3"
    # Open3.popen3("#{bin}/example", "argument") do |stdin, stdout, _|
    #   stdin.write("some text")
    #   stdin.close
    #   assert_equal "result", stdout.read
    # end</pre>
    #
    # The test will fail if it returns false, or if an exception is raised.
    # Failed assertions and failed `system` commands will raise exceptions.
    def test(&block)
      define_method(:test, &block)
    end

    # Defines whether the {Formula}'s bottle can be used on the given Homebrew
    # installation.
    #
    # For example, if the bottle requires the Xcode CLT to be installed a
    # {Formula} would declare:
    # <pre>pour_bottle? do
    #   reason "The bottle needs the Xcode CLT to be installed."
    #   satisfy { MacOS::CLT.installed? }
    # end</pre>
    #
    # If `satisfy` returns `false` then a bottle will not be used and instead
    # the {Formula} will be built from source and `reason` will be printed.
    def pour_bottle?(&block)
      @pour_bottle_check = PourBottleCheck.new(self)
      @pour_bottle_check.instance_eval(&block)
    end

    # @private
    def link_overwrite(*paths)
      paths.flatten!
      link_overwrite_paths.merge(paths)
    end

    # @private
    def link_overwrite_paths
      @link_overwrite_paths ||= Set.new
    end
  end
end
