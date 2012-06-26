require 'download_strategy'
require 'checksums'

class SoftwareSpec
  attr_reader :checksum, :mirrors, :specs

  # Was the version defined in the DSL, or detected from the URL?
  def explicit_version?
    @explicit_version || false
  end

  def download_strategy
    @download_strategy ||= DownloadStrategyDetector.new(@url, @using).detect
  end

  def verify_download_integrity fn
    fn.verify_checksum @checksum
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

  # The methods that follow are used in the block-form DSL spec methods
  Checksum::TYPES.each do |cksum|
    class_eval %Q{
      def #{cksum}(val=nil)
        if val.nil?
          @checksum if @checksum.nil? or @checksum.hash_type == :#{cksum}
        else
          @checksum = Checksum.new(:#{cksum}, val)
        end
      end
    }
  end

  def url val=nil, specs=nil
    return @url if val.nil?
    @url = val
    if specs.nil?
      @using = nil
    else
      @using = specs.delete :using
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
  end

  def verify_download_integrity fn
    return
  end
end

class Bottle < SoftwareSpec
  attr_writer :url
  attr_reader :revision

  def initialize
    super
    @revision = 0
  end

  # Checksum methods in the DSL's bottle block optionally take
  # a Hash, which indicates the platform the checksum applies on.
  Checksum::TYPES.each do |cksum|
    class_eval %Q{
      def #{cksum}(val=nil)
        @#{cksum} ||= Hash.new
        case val
        when nil
          @#{cksum}[MacOS.cat]
        when String
          @#{cksum}[:lion] = Checksum.new(:#{cksum}, val)
        when Hash
          key, value = val.shift
          @#{cksum}[value] = Checksum.new(:#{cksum}, key)
        end

        @checksum = @#{cksum}[MacOS.cat] if @#{cksum}.has_key? MacOS.cat
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
