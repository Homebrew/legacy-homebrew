require 'formula_support'
require 'formula_lock'
require 'formula_pin'
require 'hardware'
require 'bottles'
require 'compilers'
require 'build_environment'
require 'build_options'
require 'formulary'
require 'software_spec'
require 'install_renamed'
require 'pkg_version'

class Formula
  include FileUtils
  include Utils::Inreplace
  extend Enumerable

  attr_reader :name, :path, :homepage, :build
  attr_reader :stable, :devel, :head, :active_spec
  attr_reader :pkg_version, :revision

  # The current working directory during builds and tests.
  # Will only be non-nil inside #stage and #test.
  attr_reader :buildpath, :testpath

  attr_accessor :local_bottle_path

  def initialize(name, path, spec)
    @name = name
    @path = path
    @homepage = self.class.homepage
    @revision = self.class.revision || 0

    set_spec :stable
    set_spec :devel
    set_spec :head

    @active_spec = determine_active_spec(spec)
    validate_attributes :url, :name, :version
    @build = determine_build_options
    @pkg_version = PkgVersion.new(version, revision)

    @pin = FormulaPin.new(self)
  end

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

  def validate_attributes(*attrs)
    attrs.each do |attr|
      if (value = send(attr).to_s).empty? || value =~ /\s/
        raise FormulaValidationError.new(attr, value)
      end
    end
  end

  def determine_build_options
    build = active_spec.build
    options.each { |opt, desc| build.add(opt, desc) }
    build
  end

  def bottle
    Bottle.new(self, active_spec.bottle_specification) if active_spec.bottled?
  end

  def url;      active_spec.url;     end
  def version;  active_spec.version; end
  def mirrors;  active_spec.mirrors; end

  def resource(name)
    active_spec.resource(name)
  end

  def resources
    active_spec.resources.values
  end

  def deps
    active_spec.deps
  end

  def requirements
    active_spec.requirements
  end

  def cached_download
    active_spec.cached_download
  end

  def clear_cache
    active_spec.clear_cache
  end

  def patchlist
    active_spec.patches
  end

  # if the dir is there, but it's empty we consider it not installed
  def installed?
    (dir = installed_prefix).directory? && dir.children.length > 0
  end

  def linked_keg
    Pathname.new("#{HOMEBREW_LIBRARY}/LinkedKegs/#{name}")
  end

  def installed_prefix
    if head && (head_prefix = prefix(head.version)).directory?
      head_prefix
    elsif devel && (devel_prefix = prefix(devel.version)).directory?
      devel_prefix
    else
      prefix
    end
  end

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

  def bin;     prefix+'bin'     end
  def doc;     share+'doc'+name end
  def include; prefix+'include' end
  def info;    share+'info'     end
  def lib;     prefix+'lib'     end
  def libexec; prefix+'libexec' end
  def man;     share+'man'      end
  def man1;    man+'man1'       end
  def man2;    man+'man2'       end
  def man3;    man+'man3'       end
  def man4;    man+'man4'       end
  def man5;    man+'man5'       end
  def man6;    man+'man6'       end
  def man7;    man+'man7'       end
  def man8;    man+'man8'       end
  def sbin;    prefix+'sbin'    end
  def share;   prefix+'share'   end

  def frameworks; prefix+'Frameworks' end
  def kext_prefix; prefix+'Library/Extensions' end

  # configuration needs to be preserved past upgrades
  def etc; (HOMEBREW_PREFIX+'etc').extend(InstallRenamed) end

  # generally we don't want var stuff inside the keg
  def var; HOMEBREW_PREFIX+'var' end

  def bash_completion; prefix+'etc/bash_completion.d' end
  def zsh_completion;  share+'zsh/site-functions'     end

  # for storing etc, var files for later copying from bottles
  def bottle_prefix; prefix+'.bottle' end

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

  # Can be overridden to selectively disable bottles from formulae.
  # Defaults to true so overridden version does not have to check if bottles
  # are supported.
  def pour_bottle?; true end

  # Can be overridden to run commands on both source and bottle installation.
  def post_install; end

  # tell the user about any caveats regarding this package, return a string
  def caveats; nil end

  # any e.g. configure options for this package
  def options; [] end

  def patches; {} end

  # rarely, you don't want your library symlinked into the main prefix
  # see gettext.rb for an example
  def keg_only?
    kor = self.class.keg_only_reason
    not kor.nil? and kor.valid?
  end

  def keg_only_reason
    self.class.keg_only_reason
  end

  def fails_with? cc
    cc = Compiler.new(cc) unless cc.is_a? Compiler
    (self.class.cc_failures || []).any? do |failure|
      # Major version check distinguishes between, e.g.,
      # GCC 4.7.1 and GCC 4.8.2, where a comparison is meaningless
      failure.compiler == cc.name && failure.major_version == cc.major_version &&
        failure.version >= (cc.version || 0)
    end
  end

  # sometimes the formula cleaner breaks things
  # skip cleaning paths in a formula with a class method like this:
  #   skip_clean "bin/foo", "lib"bar"
  # keep .la files with:
  #   skip_clean :la
  def skip_clean? path
    return true if path.extname == '.la' and self.class.skip_clean_paths.include? :la
    to_check = path.relative_path_from(prefix).to_s
    self.class.skip_clean_paths.include? to_check
  end

  # yields self with current working directory set to the uncompressed tarball
  def brew
    validate_attributes :name, :version

    stage do
      begin
        patch
        # we allow formulae to do anything they want to the Ruby process
        # so load any deps before this point! And exit asap afterwards
        yield self
      rescue RuntimeError, SystemCallError
        %w(config.log CMakeCache.txt).each do |fn|
          (HOMEBREW_LOGS/name).install(fn) if File.file?(fn)
        end
        raise
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
  def <=> b
    name <=> b.name
  end
  def to_s
    name
  end
  def inspect
    name
  end

  # Standard parameters for CMake builds.
  # Using Build Type "None" tells cmake to use our CFLAGS,etc. settings.
  # Setting it to Release would ignore our flags.
  # Setting CMAKE_FIND_FRAMEWORK to "LAST" tells CMake to search for our
  # libraries before trying to utilize Frameworks, many of which will be from
  # 3rd party installs.
  # Note: there isn't a std_autotools variant because autotools is a lot
  # less consistent and the standard parameters are more memorable.
  def std_cmake_args
    %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_BUILD_TYPE=None
      -DCMAKE_FIND_FRAMEWORK=LAST
      -DCMAKE_VERBOSE_MAKEFILE=ON
      -Wno-dev
    ]
  end

  # Deprecated
  def python(options={}, &block)
    opoo 'Formula#python is deprecated and will go away shortly.'
    block.call if block_given?
    PythonDependency.new
  end
  alias_method :python2, :python
  alias_method :python3, :python

  # an array of all Formula names
  def self.names
    Dir["#{HOMEBREW_LIBRARY}/Formula/*.rb"].map{ |f| File.basename f, '.rb' }.sort
  end

  def self.each
    names.each do |name|
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

  # An array of all installed formulae
  def self.installed
    return [] unless HOMEBREW_CELLAR.directory?

    HOMEBREW_CELLAR.subdirs.map do |rack|
      begin
        Formulary.factory(rack.basename.to_s)
      rescue FormulaUnavailableError
      end
    end.compact
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
    else
      "path or URL"
    end
  end

  # True if this formula is provided by Homebrew itself
  def core_formula?
    path == Formula.path(name)
  end

  def self.path name
    Pathname.new("#{HOMEBREW_LIBRARY}/Formula/#{name.downcase}.rb")
  end

  def env
    @env ||= self.class.env
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
      "dependencies" => deps.map(&:name),
      "conflicts_with" => conflicts.map(&:name),
      "caveats" => caveats
    }

    hsh["options"] = build.map { |opt|
      { "option" => opt.flag, "description" => opt.description }
    }

    if rack.directory?
      rack.subdirs.each do |keg_path|
        keg = Keg.new keg_path
        tab = Tab.for_keg keg_path

        hsh["installed"] << {
          "version" => keg.version.to_s,
          "used_options" => tab.used_options.map(&:flag),
          "built_as_bottle" => tab.built_bottle,
          "poured_from_bottle" => tab.poured_from_bottle
        }
      end
    end

    hsh

  end

  # For brew-fetch and others.
  def fetch
    active_spec.fetch
  end

  # For FormulaInstaller.
  def verify_download_integrity fn
    active_spec.verify_download_integrity(fn)
  end

  def test
    # Adding the used options allows us to use `build.with?` inside of tests
    tab = Tab.for_name(name)
    tab.used_options.each { |opt| build.args << opt unless build.has_opposite_of? opt }
    ret = nil
    mktemp do
      @testpath = Pathname.pwd
      ret = instance_eval(&self.class.test)
      @testpath = nil
    end
    ret
  end

  def test_defined?
    not self.class.instance_variable_get(:@test_defined).nil?
  end

  protected

  # Pretty titles the command and buffers stdout/stderr
  # Throws if there's an error
  def system cmd, *args
    rd, wr = IO.pipe

    # remove "boring" arguments so that the important ones are more likely to
    # be shown considering that we trim long ohai lines to the terminal width
    pretty_args = args.dup
    if cmd == "./configure" and not ARGV.verbose?
      pretty_args.delete "--disable-dependency-tracking"
      pretty_args.delete "--disable-debug"
    end
    ohai "#{cmd} #{pretty_args*' '}".strip

    @exec_count ||= 0
    @exec_count += 1
    logd = HOMEBREW_LOGS/name
    logfn = "#{logd}/%02d.%s" % [@exec_count, File.basename(cmd).split(' ').first]
    mkdir_p(logd)

    pid = fork do
      ENV['HOMEBREW_CC_LOG_PATH'] = logfn

      # TODO system "xcodebuild" is deprecated, this should be removed soon.
      if cmd.to_s.start_with? "xcodebuild"
        ENV.remove_cc_etc
      end

      # Turn on argument filtering in the superenv compiler wrapper.
      # We should probably have a better mechanism for this than adding
      # special cases to this method.
      if cmd == "python" && %w[setup.py build.py].include?(args.first)
        ENV.refurbish_args
      end

      rd.close
      $stdout.reopen wr
      $stderr.reopen wr
      args.collect!{|arg| arg.to_s}
      exec(cmd, *args) rescue nil
      puts "Failed to execute: #{cmd}"
      exit! 1 # never gets here unless exec threw or failed
    end
    wr.close

    File.open(logfn, 'w') do |f|
      while buf = rd.gets
        f.puts buf
        puts buf if ARGV.verbose?
      end

      Process.wait(pid)

      $stdout.flush

      unless $?.success?
        f.flush
        Kernel.system "/usr/bin/tail", "-n", "5", logfn unless ARGV.verbose?
        f.puts
        require 'cmd/config'
        Homebrew.write_build_config(f)
        raise BuildError.new(self, cmd, args)
      end
    end
  ensure
    rd.close unless rd.closed?
  end

  private

  def stage
    active_spec.stage do
      @buildpath = Pathname.pwd
      yield
      @buildpath = nil
    end
  end

  def patch
    active_spec.add_legacy_patches(patches)
    return if patchlist.empty?

    active_spec.patches.select(&:external?).each do |patch|
      patch.verify_download_integrity(patch.fetch)
    end

    ohai "Patching"
    active_spec.patches.each(&:apply)
  end

  def self.method_added method
    case method
    when :brew
      raise "You cannot override Formula#brew in class #{name}"
    when :test
      @test_defined = true
    end
  end

  # The methods below define the formula DSL.
  class << self
    include BuildEnvironmentDSL

    attr_reader :keg_only_reason, :cc_failures
    attr_rw :homepage, :plist_startup, :plist_manual, :revision

    def specs
      @specs ||= [stable, devel, head].freeze
    end

    def url val, specs={}
      stable.url(val, specs)
    end

    def version val=nil
      stable.version(val)
    end

    def mirror val
      stable.mirror(val)
    end

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

    # Define a named resource using a SoftwareSpec style block
    def resource name, &block
      specs.each do |spec|
        spec.resource(name, &block) unless spec.resource?(name)
      end
    end

    def depends_on dep
      specs.each { |spec| spec.depends_on(dep) }
    end

    def option name, description=nil
      specs.each { |spec| spec.option(name, description) }
    end

    def patch strip=:p1, io=nil, &block
      specs.each { |spec| spec.patch(strip, io, &block) }
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

    def keg_only reason, explanation=nil
      @keg_only_reason = KegOnlyReason.new(reason, explanation.to_s.chomp)
    end

    # Flag for marking whether this formula needs C++ standard library
    # compatibility check
    def cxxstdlib
      @cxxstdlib ||= Set.new
    end

    # Explicitly request changing C++ standard library compatibility check
    # settings. Use with caution!
    def cxxstdlib_check check_type
      cxxstdlib << check_type
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
      @cc_failures ||= Set.new
      @cc_failures << CompilerFailure.new(compiler, &block)
    end

    def needs *standards
      @cc_failures ||= Set.new
      standards.each do |standard|
        @cc_failures.merge CompilerFailure.for_standard standard
      end
    end

    def require_universal_deps
      specs.each { |spec| spec.build.universal = true }
    end

    def test &block
      return @test unless block_given?
      @test_defined = true
      @test = block
    end
  end
end

require 'formula_specialties'
