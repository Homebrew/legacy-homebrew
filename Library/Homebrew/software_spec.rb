require 'forwardable'
require 'resource'
require 'checksum'
require 'version'
require 'build_options'
require 'dependency_collector'
require 'bottles'
require 'patch'

class SoftwareSpec
  extend Forwardable

  attr_reader :name, :owner
  attr_reader :build, :resources, :patches
  attr_reader :dependency_collector
  attr_reader :bottle_specification

  def_delegators :@resource, :stage, :fetch, :verify_download_integrity
  def_delegators :@resource, :cached_download, :clear_cache
  def_delegators :@resource, :checksum, :mirrors, :specs, :using, :downloader
  def_delegators :@resource, :version, :mirror, *Checksum::TYPES

  def initialize
    @resource = Resource.new
    @resources = {}
    @build = BuildOptions.new(ARGV.options_only)
    @dependency_collector = DependencyCollector.new
    @bottle_specification = BottleSpecification.new
    @patches = []
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

  def resource? name
    resources.has_key?(name)
  end

  def resource name, &block
    if block_given?
      raise DuplicateResourceError.new(name) if resource?(name)
      res = Resource.new(name, &block)
      resources[name] = res
      dependency_collector.add(res)
    else
      resources.fetch(name) { raise ResourceMissingError.new(owner, name) }
    end
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
    build.add_dep_option(dep) if dep
  end

  def deps
    dependency_collector.deps
  end

  def requirements
    dependency_collector.requirements
  end

  def patch strip=:p1, io=nil, &block
    patches << Patch.create(strip, io, &block)
  end

  def add_legacy_patches(list)
    list = Patch.normalize_legacy_patches(list)
    list.each { |p| p.owner = self }
    patches.concat(list)
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
  extend Forwardable

  attr_reader :name, :resource, :prefix, :cellar, :revision

  def_delegators :resource, :url, :fetch, :verify_download_integrity
  def_delegators :resource, :downloader, :cached_download, :clear_cache

  def initialize(f, spec)
    @name = f.name
    @resource = Resource.new
    @resource.owner = f

    checksum, tag = spec.checksum_for(bottle_tag)

    @resource.url = bottle_url(
      spec.root_url,
      :name => f.name,
      :version => f.pkg_version,
      :revision => spec.revision,
      :tag => tag
    )
    @resource.download_strategy = CurlBottleDownloadStrategy
    @resource.version = f.pkg_version
    @resource.checksum = checksum
    @prefix = spec.prefix
    @cellar = spec.cellar
    @revision = spec.revision
  end

  def compatible_cellar?
    cellar == :any || cellar == HOMEBREW_CELLAR.to_s
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
    !!collector.fetch_bottle_for(tag)
  end

  # Checksum methods in the DSL's bottle block optionally take
  # a Hash, which indicates the platform the checksum applies on.
  Checksum::TYPES.each do |cksum|
    define_method(cksum) do |val|
      digest, tag = val.shift
      collector.add(Checksum.new(cksum, digest), tag)
    end
  end

  def checksum_for(tag)
    collector.fetch_bottle_for(tag)
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
