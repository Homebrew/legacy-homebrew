require 'download_strategy'
require 'checksums'
require 'version'

class SoftwareSpec
  attr_reader :checksum, :mirrors, :specs

  def initialize url=nil, version=nil
    @url = url
    @version = version
    @mirrors = []
    @specs = {}
  end

  def download_strategy
    @download_strategy ||= DownloadStrategyDetector.detect(@url, @using)
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

  def url val=nil, specs={}
    return @url if val.nil?
    @url = val
    @using = specs.delete(:using)
    @specs.merge!(specs)
  end

  def version val=nil
    @version ||= case val
      when nil then Version.parse(@url)
      when Hash
        key, value = val.shift
        scheme = VersionSchemeDetector.new(value).detect
        scheme.new(key)
      else Version.new(val)
      end
  end

  def mirror val
    @mirrors ||= []
    @mirrors << val
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
  attr_reader :revision
  # TODO: Can be removed when all bottles migrated to underscored cat symbols.
  attr_reader :cat_without_underscores

  def initialize url=nil, version=nil
    super
    @revision = 0
    @cat_without_underscores = false
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

        if @#{cksum}.has_key? MacOS.cat
          @checksum = @#{cksum}[MacOS.cat]
        elsif @#{cksum}.has_key? MacOS.cat_without_underscores
          @checksum = @#{cksum}[MacOS.cat_without_underscores]
          @cat_without_underscores = true
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
      return @version ||= Version.parse(@url)
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
    @valid = case @reason
      when :provided_pre_mountain_lion then MacOS.version < :mountain_lion
      else true
      end
  end

  def valid?
    @valid
  end

  def to_s
    case @reason
    when :provided_by_osx then <<-EOS.undent
      Mac OS X already provides this software and installing another version in
      parallel can cause all kinds of trouble.

      #{@explanation}
      EOS
    when :provided_pre_mountain_lion then <<-EOS.undent
      Mac OS X already provides this software in versions before Mountain Lion.

      #{@explanation}
      EOS
    else
      @reason
    end.strip
  end
end
