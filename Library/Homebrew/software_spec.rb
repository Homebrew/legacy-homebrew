require 'forwardable'
require 'resource'
require 'checksum'
require 'version'
require 'build_options'
require 'dependency_collector'
require 'bottles'

class SoftwareSpec
  extend Forwardable

  attr_reader :name
  attr_reader :build, :resources, :owner
  attr_reader :dependency_collector

  def_delegators :@resource, :stage, :fetch
  def_delegators :@resource, :download_strategy, :verify_download_integrity
  def_delegators :@resource, :checksum, :mirrors, :specs, :using, :downloader
  def_delegators :@resource, :version, :mirror, *Checksum::TYPES

  def initialize
    @resource = Resource.new
    @resources = {}
    @build = BuildOptions.new(ARGV.options_only)
    @dependency_collector = DependencyCollector.new
  end

  def owner= owner
    @name = owner.name
    @resource.owner = self
    resources.each_value do |r|
      r.owner     = self
      r.version ||= version
    end
  end

  def url val=nil, specs={}
    return @resource.url if val.nil?
    @resource.url(val, specs)
    dependency_collector.add(@resource)
  end

  def resource? name
    resources.has_key?(name)
  end

  def resource name, &block
    if block_given?
      raise DuplicateResourceError.new(name) if resource?(name)
      resources[name] = Resource.new(name, &block)
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

class Bottle < SoftwareSpec
  attr_rw :root_url, :prefix, :cellar, :revision
  attr_accessor :current_tag

  def_delegators :@resource, :version=, :url=

  def initialize
    super
    @revision = 0
    @prefix = '/usr/local'
    @cellar = '/usr/local/Cellar'
    @root_url = nil
  end

  # Checksum methods in the DSL's bottle block optionally take
  # a Hash, which indicates the platform the checksum applies on.
  Checksum::TYPES.each do |cksum|
    class_eval <<-EOS, __FILE__, __LINE__ + 1
      def #{cksum}(val=nil)
        return @#{cksum} if val.nil?
        @#{cksum} ||= BottleCollector.new
        case val
        when Hash
          key, value = val.shift
          @#{cksum}.add(Checksum.new(:#{cksum}, key), value)
        end

        cksum, current_tag = @#{cksum}.fetch_bottle_for(bottle_tag)
        @resource.checksum = cksum if cksum
        @current_tag = current_tag if cksum
      end
    EOS
  end

  def checksums
    checksums = {}
    Checksum::TYPES.each do |checksum_type|
      checksum_os_versions = send checksum_type
      next unless checksum_os_versions
      os_versions = checksum_os_versions.keys
      os_versions.map! {|osx| MacOS::Version.from_symbol osx rescue nil }.compact!
      os_versions.sort.reverse.each do |os_version|
        osx = os_version.to_sym
        checksum = checksum_os_versions[osx]
        checksums[checksum_type] ||= []
        checksums[checksum_type] << { checksum => osx }
      end
    end
    checksums
  end
end
