require 'download_strategy'
require 'checksums'

class SoftwareSpec
  attr_reader :checksum, :mirrors, :specs

  def initialize url=nil, version=nil
    @url = url
    @version = version
    @mirrors = []
  end

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

  def mirror val
    @mirrors ||= []
    @mirrors << val
  end
end

class HeadSoftwareSpec < SoftwareSpec
  def initialize url=nil, version='HEAD'
    super
  end

  def verify_download_integrity fn
    return
  end
end

class Bottle < SoftwareSpec
  attr_writer :url
  attr_reader :revision

  def initialize url=nil, version=nil
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
    @valid = case @reason
      when :when_xquartz_installed then MacOS::XQuartz.installed?
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
    when :when_xquartz_installed then <<-EOS.undent
      XQuartz provides this software.

      #{@explanation}
      EOS
    else
      @reason
    end.strip
  end
end


# This class holds the build-time options defined for a Formula,
# and provides named access to those options during install.
class BuildOptions
  include Enumerable

  def initialize args
    # Take a copy of the args (any string array, actually)
    @args = Array.new(args)
    # Extend it into an ARGV extension
    @args.extend(HomebrewArgvExtension)
    @options = Set.new
  end

  def add name, description=nil
    if description.nil?
      case name
      when :universal, "universal"
        description = "Build a universal binary"
      when "32-bit"
        description = "Build 32-bit only"
      else
        description = ""
      end
    end

    @options << [name, description]
  end

  def has_option? name
    @options.any? { |opt, _| opt == name }
  end

  def empty?
    @options.empty?
  end

  def each
    @options.each { |opt, desc| yield opt, desc }
  end

  def include? name
    @args.include? '--' + name
  end

  def head?
    @args.flag? '--HEAD'
  end

  def devel?
    @args.include? '--devel'
  end

  def stable?
    not (head? or devel?)
  end

  # True if the user requested a universal build.
  def universal?
    @args.include? '--universal'
  end

  # Request a 32-bit only build.
  # This is needed for some use-cases though we prefer to build Universal
  # when a 32-bit version is needed.
  def build_32_bit?
    @args.include? '--32-bit'
  end
end
