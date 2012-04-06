require 'download_strategy'

class SoftwareSpec
  attr_reader :checksum, :mirrors, :specs, :strategy

  CHECKSUM_TYPES = [:md5, :sha1, :sha256].freeze

  VCS_SYMBOLS = {
    :bzr     => BazaarDownloadStrategy,
    :curl    => CurlDownloadStrategy,
    :cvs     => CVSDownloadStrategy,
    :git     => GitDownloadStrategy,
    :hg      => MercurialDownloadStrategy,
    :nounzip => NoUnzipCurlDownloadStrategy,
    :post    => CurlPostDownloadStrategy,
    :svn     => SubversionDownloadStrategy,
  }

  # Detect which type of checksum is being used, or nil if none
  def checksum_type
    @checksum_type ||= CHECKSUM_TYPES.detect do |type|
      instance_variable_defined?("@#{type}")
    end
  end

  def has_checksum?
    (checksum_type and self.send(checksum_type)) || false
  end

  # Was the version defined in the DSL, or detected from the URL?
  def explicit_version?
    @explicit_version || false
  end

  # Returns a suitable DownloadStrategy class that can be
  # used to retrieve this software package.
  def download_strategy
    return detect_download_strategy(@url) if @strategy.nil?

    # If a class is passed, assume it is a download strategy
    return @strategy if @strategy.kind_of? Class

    detected = VCS_SYMBOLS[@strategy]
    raise "Unknown strategy #{@strategy} was requested." unless detected
    return detected
  end

  # The methods that follow are used in the block-form DSL spec methods
  CHECKSUM_TYPES.each do |cksum|
    class_eval %Q{
      def #{cksum}(val=nil)
        val.nil? ? @#{cksum} : @#{cksum} = val
      end
    }
  end

  def url val=nil, specs=nil
    return @url if val.nil?
    @url = val
    if specs.nil?
      @strategy = nil
    else
      @strategy = specs.delete :using
      @specs = specs
    end
  end

  def version val=nil
    unless val.nil?
      @version = val
      @explicit_version = true
    end
    @version ||= Pathname.new(@url).version
    return @version
  end

  def mirror val, specs=nil
    @mirrors ||= []
    @mirrors << { :url => val, :specs => specs }
  end
end

class HeadSoftwareSpec < SoftwareSpec
  def initialize
    super
    @version = 'HEAD'
    @checksum = nil
  end

  def verify_download_integrity fn
    return
  end
end

class Bottle < SoftwareSpec
  attr_writer :url
  attr_reader :revision

  def initialize
    @revision = 0
    @strategy = CurlBottleDownloadStrategy
  end

  # Checksum methods in the DSL's bottle block optionally take
  # a Hash, which indicates the platform the checksum applies on.
  CHECKSUM_TYPES.each do |cksum|
    class_eval %Q{
      def #{cksum}(val=nil)
        @#{cksum} ||= Hash.new
        case val
        when nil
          @#{cksum}[MacOS.cat]
        when String
          @#{cksum}[:lion] = val
        when Hash
          key, value = val.shift
          @#{cksum}[value] = key
        end
      end
    }
  end

  def url val=nil
    val.nil? ? @url : @url = val
  end

  # Used in the bottle DSL to set @revision, but acts as an
  # as accessor for @version to preserve the interface
  def version val=nil
    if val.nil?
      return @version ||= Pathname.new(@url).version
    else
      @revision = val
    end
  end
end


# Used to annotate formulae that duplicate OS X provided software
# or cause conflicts when linked in.
class KegOnlyReason
  attr_reader :reason, :explanation

  def initialize reason, explanation=nil
    @reason = reason
    @explanation = explanation
  end

  def to_s
    if @reason == :provided_by_osx
      <<-EOS.strip
Mac OS X already provides this program and installing another version in
parallel can cause all kinds of trouble.

#{@explanation}
EOS
    else
      @reason.strip
    end
  end
end
