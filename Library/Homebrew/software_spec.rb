require 'forwardable'
require 'resource'
require 'checksum'
require 'version'

class SoftwareSpec
  extend Forwardable

  attr_reader :resources, :owner

  def_delegators :@resource, :stage, :fetch
  def_delegators :@resource, :download_strategy, :verify_download_integrity
  def_delegators :@resource, :checksum, :mirrors, :specs, :using, :downloader
  def_delegators :@resource, :url, :version, :mirror, *Checksum::TYPES

  def initialize url=nil, version=nil
    @resource = Resource.new(:default, url, version)
    @resources = {}
  end

  def owner= owner
    @resource.owner = owner
    resources.each_value { |r| r.owner = owner }
  end

  def resource name, &block
    if block_given?
      raise DuplicateResourceError.new(name) if resources.has_key?(name)
      resources[name] = Resource.new(name, &block)
    else
      resources.fetch(name) { raise ResourceMissingError.new(owner, name) }
    end
  end
end

class HeadSoftwareSpec < SoftwareSpec
  def initialize url=nil, version=Version.new(:HEAD)
    super
  end

  def verify_download_integrity fn
    return
  end
end

class Bottle < SoftwareSpec
  attr_rw :root_url, :prefix, :cellar, :revision

  def_delegators :@resource, :url=

  def initialize
    super
    @revision = 0
    @prefix = '/usr/local'
    @cellar = '/usr/local/Cellar'
  end

  # Checksum methods in the DSL's bottle block optionally take
  # a Hash, which indicates the platform the checksum applies on.
  Checksum::TYPES.each do |cksum|
    class_eval <<-EOS, __FILE__, __LINE__ + 1
      def #{cksum}(val=nil)
        return @#{cksum} if val.nil?
        @#{cksum} ||= Hash.new
        case val
        when Hash
          key, value = val.shift
          @#{cksum}[value] = Checksum.new(:#{cksum}, key)
        end

        if @#{cksum}.has_key? bottle_tag
          @resource.checksum = @#{cksum}[bottle_tag]
        end
      end
    EOS
  end
end
