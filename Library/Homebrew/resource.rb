require 'download_strategy'
require 'checksum'
require 'version'

# Resource is the fundamental representation of an external resource. The
# primary formula download, along with other declared resources, are instances
# of this class.
class Resource
  include FileUtils

  attr_reader :checksum, :mirrors, :specs, :using
  attr_writer :url, :checksum, :version, :download_strategy

  # Formula name must be set after the DSL, as we have no access to the
  # formula name before initialization of the formula
  attr_accessor :name, :owner

  def initialize name=nil, &block
    @name = name
    @url = nil
    @version = nil
    @mirrors = []
    @specs = {}
    @checksum = nil
    @using = nil
    instance_eval(&block) if block_given?
  end

  def downloader
    @downloader ||= download_strategy.new(download_name, self)
  end

  def download_name
    name.nil? ? owner.name : "#{owner.name}--#{name}"
  end

  def download_strategy
    @download_strategy ||= DownloadStrategyDetector.detect(url, using)
  end

  def cached_download
    downloader.cached_location
  end

  def clear_cache
    downloader.clear_cache
  end

  # Fetch, verify, and unpack the resource
  def stage(target=nil, &block)
    verify_download_integrity(fetch)
    unpack(target, &block)
  end

  # If a target is given, unpack there; else unpack to a temp folder
  # If block is given, yield to that block
  # A target or a block must be given, but not both
  def unpack(target=nil)
    mktemp(download_name) do
      downloader.stage
      if block_given?
        yield self
      elsif target
        target = Pathname.new(target) unless target.is_a? Pathname
        target.install Dir['*']
      end
    end
  end

  Partial = Struct.new(:resource, :files)

  def files(*files)
    Partial.new(self, files)
  end

  # For brew-fetch and others.
  def fetch
    # Ensure the cache exists
    HOMEBREW_CACHE.mkpath
    downloader.fetch
  rescue ErrorDuringExecution, CurlDownloadStrategyError => e
    raise DownloadError.new(self, e)
  else
    cached_download
  end

  def verify_download_integrity fn
    if fn.respond_to?(:file?) && fn.file?
      ohai "Verifying #{fn.basename} checksum" if ARGV.verbose?
      fn.verify_checksum(checksum)
    end
  rescue ChecksumMissingError
    opoo "Cannot verify integrity of #{fn.basename}"
    puts "A checksum was not provided for this resource"
    puts "For your reference the SHA1 is: #{fn.sha1}"
  end

  Checksum::TYPES.each do |type|
    define_method(type) { |val| @checksum = Checksum.new(type, val) }
  end

  def url val=nil, specs={}
    return @url if val.nil?
    @url = val
    @specs.merge!(specs)
    @using = @specs.delete(:using)
  end

  def version val=nil
    @version ||= detect_version(val)
  end

  def mirror val
    mirrors << val
  end

  private

  def detect_version(val)
    case val
    when nil     then Version.detect(url, specs)
    when String  then Version.new(val)
    when Version then val
    else
      raise TypeError, "version '#{val.inspect}' should be a string"
    end
  end
end
