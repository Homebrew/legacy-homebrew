require 'download_strategy'
require 'checksum'
require 'version'

class SoftwareSpec
  attr_reader :checksum, :mirrors, :specs
  attr_reader :using # for auditing

  def initialize url=nil, version=nil
    @url = url
    @version = version
    @mirrors = []
    @specs = {}
    @checksum = nil
    @using = nil
  end

  def download_strategy
    @download_strategy ||= DownloadStrategyDetector.detect(url, using)
  end

  def verify_download_integrity fn
    fn.verify_checksum(checksum)
  rescue ChecksumMissingError
    opoo "Cannot verify package integrity"
    puts "The formula did not provide a download checksum"
    puts "For your reference the SHA1 is: #{fn.sha1}"
  rescue ChecksumMismatchError => e
    e.advice = <<-EOS.undent
    Archive: #{fn}
    (To retry an incomplete download, remove the file above.)
    EOS
    raise e
  end

  def detect_version(val)
    case val
    when nil    then Version.detect(url, specs)
    when String then Version.new(val)
    when Hash   then Version.new_with_scheme(*val.shift)
    else
      raise TypeError, "version '#{val.inspect}' should be a string"
    end
  end

  # The methods that follow are used in the block-form DSL spec methods
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
  attr_writer :url
  attr_rw :root_url, :prefix, :cellar, :revision

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
          @checksum = @#{cksum}[bottle_tag]
        end
      end
    EOS
  end
end
