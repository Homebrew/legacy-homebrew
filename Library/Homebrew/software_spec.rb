require 'forwardable'
require 'resource'
require 'checksum'
require 'version'
require 'options'
require 'build_options'
require 'dependency_collector'
require 'bottles'
require 'patch'

class SoftwareSpec
  extend Forwardable

  attr_reader :name, :owner
  attr_reader :build, :resources, :patches, :options
  attr_reader :dependency_collector
  attr_reader :bottle_specification

  def_delegators :@resource, :stage, :fetch, :verify_download_integrity
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
    @build = BuildOptions.new(ARGV.options_only, options)
  end

  def owner= owner
    @name = owner.name
    @owner = owner
    @resource.owner = self
    resources.each_value do |r|
      r.owner     = self
      r.version ||= version
    end
    patches.each { |p| p.owner = self }
  end

  def url val=nil, specs={}
    return @resource.url if val.nil?
    @resource.url(val, specs)
    dependency_collector.add(@resource)
  end

  def bottled?
    bottle_specification.tag?(bottle_tag)
  end

  def bottle &block
    bottle_specification.instance_eval(&block)
  end

  def resource_defined? name
    resources.has_key?(name)
  end

  def resource name, &block
    if block_given?
      raise DuplicateResourceError.new(name) if resource_defined?(name)
      res = Resource.new(name, &block)
      resources[name] = res
      dependency_collector.add(res)
    else
      resources.fetch(name) { raise ResourceMissingError.new(owner, name) }
    end
  end

  def option_defined?(name)
    options.include?(name)
  end

  def option name, description=nil
    name = 'c++11' if name == :cxx11
    name = name.to_s if Symbol === name
    raise "Option name is required." if name.empty?
    raise "Options should not start with dashes." if name[0, 1] == "-"
    build.add(name, description)
  end

  def depends_on spec
    dep = dependency_collector.add(spec)
    add_dep_option(dep) if dep
  end

  def deps
    dependency_collector.deps
  end

  def requirements
    dependency_collector.requirements
  end

  def patch strip=:p1, src=nil, &block
    patches << Patch.create(strip, src, &block)
  end

  def add_legacy_patches(list)
    list = Patch.normalize_legacy_patches(list)
    list.each { |p| p.owner = self }
    patches.concat(list)
  end

  def add_dep_option(dep)
    name = dep.option_name

    if dep.optional? && !option_defined?("with-#{name}")
      options << Option.new("with-#{name}", "Build with #{name} support")
    elsif dep.recommended? && !option_defined?("without-#{name}")
      options << Option.new("without-#{name}", "Build without #{name} support")
    end
  end
end

class HeadSoftwareSpec < SoftwareSpec
  def initialize
    super
    @resource.version = Version.new('HEAD')
  end

  def verify_download_integrity fn
    return
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

    checksum, tag = spec.checksum_for(bottle_tag)

    filename = Filename.create(formula, tag, spec.revision)
    @resource.url = build_url(spec.root_url, filename)
    @resource.download_strategy = CurlBottleDownloadStrategy
    @resource.version = formula.pkg_version
    @resource.checksum = checksum
    @prefix = spec.prefix
    @cellar = spec.cellar
    @revision = spec.revision
  end

  def compatible_cellar?
    cellar == :any || cellar == HOMEBREW_CELLAR.to_s
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
  DEFAULT_ROOT_URL = "https://downloads.sf.net/project/machomebrew/Bottles".freeze

  attr_rw :root_url, :prefix, :cellar, :revision
  attr_reader :checksum, :collector

  def initialize
    @revision = 0
    @prefix = DEFAULT_PREFIX
    @cellar = DEFAULT_CELLAR
    @root_url = DEFAULT_ROOT_URL
    @collector = BottleCollector.new
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
    os_versions.map! {|osx| MacOS::Version.from_symbol osx rescue nil }.compact!
    os_versions.sort.reverse_each do |os_version|
      osx = os_version.to_sym
      checksum = collector[osx]
      checksums[checksum.hash_type] ||= []
      checksums[checksum.hash_type] << { checksum => osx }
    end
    checksums
  end
end
