require "forwardable"
require "resource"
require "checksum"
require "version"
require "options"
require "build_options"
require "dependency_collector"
require "bottles"
require "patch"
require "compilers"

class SoftwareSpec
  extend Forwardable

  PREDEFINED_OPTIONS = {
    :universal => Option.new("universal", "Build a universal binary"),
    :cxx11     => Option.new("c++11", "Build using C++11 mode"),
    "32-bit"   => Option.new("32-bit", "Build 32-bit only")
  }

  attr_reader :name, :full_name, :owner
  attr_reader :build, :resources, :patches, :options
  attr_reader :deprecated_flags, :deprecated_options
  attr_reader :dependency_collector
  attr_reader :bottle_specification
  attr_reader :compiler_failures

  def_delegators :@resource, :stage, :fetch, :verify_download_integrity, :source_modified_time
  def_delegators :@resource, :cached_download, :clear_cache
  def_delegators :@resource, :checksum, :mirrors, :specs, :using
  def_delegators :@resource, :version, :mirror, *Checksum::TYPES

  def initialize
    @resource = Resource.new
    @resources = {}
    @dependency_collector = DependencyCollector.new
    @bottle_specification = BottleSpecification.new
    @patches = []
    @options = Options.new
    @flags = ARGV.flags_only
    @deprecated_flags = []
    @deprecated_options = []
    @build = BuildOptions.new(Options.create(@flags), options)
    @compiler_failures = []
  end

  def owner=(owner)
    @name = owner.name
    @full_name = owner.full_name
    @bottle_specification.tap = owner.tap
    @owner = owner
    @resource.owner = self
    resources.each_value do |r|
      r.owner     = self
      r.version ||= version
    end
    patches.each { |p| p.owner = self }
  end

  def url(val = nil, specs = {})
    return @resource.url if val.nil?
    @resource.url(val, specs)
    dependency_collector.add(@resource)
  end

  def bottle_unneeded?
    !!@bottle_disable_reason && @bottle_disable_reason.unneeded?
  end

  def bottle_disabled?
    !!@bottle_disable_reason
  end

  def bottle_disable_reason
    @bottle_disable_reason
  end

  def bottle_defined?
    bottle_specification.collector.keys.any?
  end

  def bottled?
    bottle_specification.tag?(bottle_tag) && \
      (bottle_specification.compatible_cellar? || ARGV.force_bottle?)
  end

  def bottle(disable_type = nil, disable_reason = nil,  &block)
    if disable_type
      @bottle_disable_reason = BottleDisableReason.new(disable_type, disable_reason)
    else
      bottle_specification.instance_eval(&block)
    end
  end

  def resource_defined?(name)
    resources.key?(name)
  end

  def resource(name, klass = Resource, &block)
    if block_given?
      raise DuplicateResourceError.new(name) if resource_defined?(name)
      res = klass.new(name, &block)
      resources[name] = res
      dependency_collector.add(res)
    else
      resources.fetch(name) { raise ResourceMissingError.new(owner, name) }
    end
  end

  def go_resource(name, &block)
    resource name, Resource::Go, &block
  end

  def option_defined?(name)
    options.include?(name)
  end

  def option(name, description = "")
    opt = PREDEFINED_OPTIONS.fetch(name) do
      if Symbol === name
        opoo "Passing arbitrary symbols to `option` is deprecated: #{name.inspect}"
        puts "Symbols are reserved for future use, please pass a string instead"
        name = name.to_s
      end
      raise ArgumentError, "option name is required" if name.empty?
      raise ArgumentError, "option name must be longer than one character" unless name.length > 1
      raise ArgumentError, "option name must not start with dashes" if name.start_with?("-")
      Option.new(name, description)
    end
    options << opt
  end

  def deprecated_option(hash)
    raise ArgumentError, "deprecated_option hash must not be empty" if hash.empty?
    hash.each do |old_options, new_options|
      Array(old_options).each do |old_option|
        Array(new_options).each do |new_option|
          deprecated_option = DeprecatedOption.new(old_option, new_option)
          deprecated_options << deprecated_option

          old_flag = deprecated_option.old_flag
          new_flag = deprecated_option.current_flag
          if @flags.include? old_flag
            @flags -= [old_flag]
            @flags |= [new_flag]
            @deprecated_flags << deprecated_option
          end
        end
      end
    end
    @build = BuildOptions.new(Options.create(@flags), options)
  end

  def depends_on(spec)
    dep = dependency_collector.add(spec)
    add_dep_option(dep) if dep
  end

  def deps
    dependency_collector.deps
  end

  def requirements
    dependency_collector.requirements
  end

  def patch(strip = :p1, src = nil, &block)
    patches << Patch.create(strip, src, &block)
  end

  def fails_with(compiler, &block)
    compiler_failures << CompilerFailure.create(compiler, &block)
  end

  def needs(*standards)
    standards.each do |standard|
      compiler_failures.concat CompilerFailure.for_standard(standard)
    end
  end

  def add_legacy_patches(list)
    list = Patch.normalize_legacy_patches(list)
    list.each { |p| p.owner = self }
    patches.concat(list)
  end

  def add_dep_option(dep)
    dep.option_names.each do |name|
      if dep.optional? && !option_defined?("with-#{name}")
        options << Option.new("with-#{name}", "Build with #{name} support")
      elsif dep.recommended? && !option_defined?("without-#{name}")
        options << Option.new("without-#{name}", "Build without #{name} support")
      end
    end
  end
end

class HeadSoftwareSpec < SoftwareSpec
  def initialize
    super
    @resource.version = Version.new("HEAD")
  end

  def verify_download_integrity(_fn)
    nil
  end
end

class Bottle
  class Filename
    attr_reader :name, :version, :tag, :revision

    def self.create(formula, tag, revision)
      new(formula.name, formula.pkg_version, tag, revision)
    end

    def initialize(name, version, tag, revision)
      @name = name
      @version = version
      @tag = tag
      @revision = revision
    end

    def to_s
      prefix + suffix
    end
    alias_method :to_str, :to_s

    def prefix
      "#{name}-#{version}.#{tag}"
    end

    def suffix
      s = revision > 0 ? ".#{revision}" : ""
      ".bottle#{s}.tar.gz"
    end
  end

  extend Forwardable

  attr_reader :name, :resource, :prefix, :cellar, :revision

  def_delegators :resource, :url, :fetch, :verify_download_integrity
  def_delegators :resource, :cached_download, :clear_cache

  def initialize(formula, spec)
    @name = formula.name
    @resource = Resource.new
    @resource.owner = formula
    @spec = spec

    checksum, tag = spec.checksum_for(bottle_tag)

    filename = Filename.create(formula, tag, spec.revision)
    @resource.url(build_url(spec.root_url, filename))
    @resource.download_strategy = CurlBottleDownloadStrategy
    @resource.version = formula.pkg_version
    @resource.checksum = checksum
    @prefix = spec.prefix
    @cellar = spec.cellar
    @revision = spec.revision
  end

  def compatible_cellar?
    @spec.compatible_cellar?
  end

  # Does the bottle need to be relocated?
  def skip_relocation?
    @spec.skip_relocation?
  end

  def stage
    resource.downloader.stage
  end

  private

  def build_url(root_url, filename)
    "#{root_url}/#{filename}"
  end
end

class BottleSpecification
  DEFAULT_PREFIX = "/usr/local".freeze
  DEFAULT_CELLAR = "/usr/local/Cellar".freeze
  DEFAULT_DOMAIN = (ENV["HOMEBREW_BOTTLE_DOMAIN"] || "https://homebrew.bintray.com").freeze

  attr_rw :prefix, :cellar, :revision
  attr_accessor :tap
  attr_reader :checksum, :collector

  def initialize
    @revision = 0
    @prefix = DEFAULT_PREFIX
    @cellar = DEFAULT_CELLAR
    @collector = BottleCollector.new
  end

  def root_url(var = nil)
    if var.nil?
      @root_url ||= "#{DEFAULT_DOMAIN}/#{Bintray.repository(tap)}"
    else
      @root_url = var
    end
  end

  def compatible_cellar?
    cellar == :any || cellar == :any_skip_relocation || cellar == HOMEBREW_CELLAR.to_s
  end

  # Does the Bottle this BottleSpecification belongs to need to be relocated?
  def skip_relocation?
    cellar == :any_skip_relocation
  end

  def tag?(tag)
    !!checksum_for(tag)
  end

  # Checksum methods in the DSL's bottle block optionally take
  # a Hash, which indicates the platform the checksum applies on.
  Checksum::TYPES.each do |cksum|
    define_method(cksum) do |val|
      digest, tag = val.shift
      collector[tag] = Checksum.new(cksum, digest)
    end
  end

  def checksum_for(tag)
    collector.fetch_checksum_for(tag)
  end

  def checksums
    checksums = {}
    os_versions = collector.keys
    os_versions.map! { |osx| MacOS::Version.from_symbol osx rescue nil }.compact!
    os_versions.sort.reverse_each do |os_version|
      osx = os_version.to_sym
      checksum = collector[osx]
      checksums[checksum.hash_type] ||= []
      checksums[checksum.hash_type] << { checksum => osx }
    end
    checksums
  end
end

class PourBottleCheck
  def initialize(formula)
    @formula = formula
  end

  def reason(reason)
    @formula.pour_bottle_check_unsatisfied_reason(reason)
  end

  def satisfy(&block)
    @formula.send(:define_method, :pour_bottle?, &block)
  end
end
