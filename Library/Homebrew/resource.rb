require 'download_strategy'
require 'checksum'
require 'version'

# Resource is the fundamental representation of an external resource. The
# primary formula download, along with other declared resources, are instances
# of this class.
class Resource
  include FileUtils

  attr_reader :name
  attr_reader :checksum, :mirrors, :specs, :using

  # Formula name must be set after the DSL, as we have no access to the
  # formula name before initialization of the formula
  attr_accessor :owner

  # XXX: for bottles, address this later
  attr_writer :url, :checksum

  def initialize name, url=nil, version=nil, &block
    @name = name
    @url = url
    @version = version
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
    name == :default ? owner.name : "#{owner.name}--#{name}"
  end

  def download_strategy
    @download_strategy ||= DownloadStrategyDetector.detect(url, using)
  end

  def cached_download
    downloader.cached_location
  end

  # Download the resource
  # If a target is given, unpack there; else unpack to a temp folder
  # If block is given, yield to that block
  # A target or a block must be given, but not both
  def stage(target=nil)
    fetched = fetch
    verify_download_integrity(fetched) if fetched.respond_to?(:file?) and fetched.file?
    mktemp do
      downloader.stage
      if block_given?
        yield self
      else
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
    cached_download
  end

  def verify_download_integrity fn
    fn.verify_checksum(checksum)
  rescue ChecksumMissingError
    opoo "Cannot verify integrity of #{fn.basename}"
    puts "A checksum was not provided for this resource"
    puts "For your reference the SHA1 is: #{fn.sha1}"
  rescue ChecksumMismatchError => e
    e.advice = <<-EOS.undent
    Archive: #{fn}
    (To retry an incomplete download, remove the file above.)
    EOS
    raise e
  end

  Checksum::TYPES.each do |cksum|
    class_eval <<-EOS, __FILE__, __LINE__ + 1
      def #{cksum}(val)
        @checksum = Checksum.new(:#{cksum}, val)
      end
    EOS
  end

  def url val=nil, specs={}
    return @url if val.nil?
    @url = val
    @using = specs.delete(:using)
    @specs.merge!(specs)
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
    when nil    then Version.detect(url, specs)
    when String then Version.new(val)
    when Hash   then Version.new_with_scheme(*val.shift)
    else
      raise TypeError, "version '#{val.inspect}' should be a string"
    end
  end
end
