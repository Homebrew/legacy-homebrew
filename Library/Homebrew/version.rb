class Version
  include Comparable

  class Token
    include Comparable

    attr_reader :value

    def initialize(value)
      @value = value
    end

    def inspect
      "#<#{self.class} #{value.inspect}>"
    end

    def to_s
      value.to_s
    end
  end

  class NullToken < Token
    def initialize(value=nil)
      super
    end

    def <=>(other)
      case other
      when NumericToken
        other.value == 0 ? 0 : -1
      when AlphaToken, BetaToken, RCToken
        1
      else
        -1
      end
    end

    def inspect
      "#<#{self.class}>"
    end
  end

  NULL_TOKEN = NullToken.new

  class StringToken < Token
    PATTERN = /[a-z]+[0-9]+/i

    def initialize(value)
      @value = value.to_s
    end

    def <=>(other)
      case other
      when StringToken
        value <=> other.value
      when NumericToken, NullToken
        -Integer(other <=> self)
      end
    end
  end

  class NumericToken < Token
    PATTERN = /[0-9]+/i

    def initialize(value)
      @value = value.to_i
    end

    def <=>(other)
      case other
      when NumericToken
        value <=> other.value
      when StringToken
        1
      when NullToken
        -Integer(other <=> self)
      end
    end
  end

  class CompositeToken < StringToken
    def rev
      value[/([0-9]+)/, 1]
    end
  end

  class AlphaToken < CompositeToken
    PATTERN = /a(?:lpha)?[0-9]+/i

    def <=>(other)
      case other
      when AlphaToken
        rev <=> other.rev
      else
        super
      end
    end
  end

  class BetaToken < CompositeToken
    PATTERN = /b(?:eta)?[0-9]+/i

    def <=>(other)
      case other
      when BetaToken
        rev <=> other.rev
      when AlphaToken
        1
      when RCToken, PatchToken
        -1
      else
        super
      end
    end
  end

  class RCToken < CompositeToken
    PATTERN = /rc[0-9]+/i

    def <=>(other)
      case other
      when RCToken
        rev <=> other.rev
      when AlphaToken, BetaToken
        1
      when PatchToken
        -1
      else
        super
      end
    end
  end

  class PatchToken < CompositeToken
    PATTERN = /p[0-9]+/i

    def <=>(other)
      case other
      when PatchToken
        rev <=> other.rev
      when AlphaToken, BetaToken, RCToken
        1
      else
        super
      end
    end
  end

  def initialize(val, detected=false)
    @version = val.to_s
    @detected_from_url = detected
  end

  def detected_from_url?
    @detected_from_url
  end

  def head?
    @version == 'HEAD'
  end

  def <=>(other)
    return unless Version === other
    return 0 if head? && other.head?
    return 1 if head? && !other.head?
    return -1 if !head? && other.head?

    max = [tokens.length, other.tokens.length].max
    pad_to(max) <=> other.pad_to(max)
  end

  def to_s
    @version.dup
  end
  alias_method :to_str, :to_s

  protected

  def pad_to(length)
    nums, rest = tokens.partition { |t| NumericToken === t }
    nums.concat([NULL_TOKEN]*(length - tokens.length)).concat(rest)
  end

  def tokens
    @tokens ||= tokenize
  end
  alias_method :to_a, :tokens

  def tokenize
    @version.scan(
      Regexp.union(
        AlphaToken::PATTERN,
        BetaToken::PATTERN,
        RCToken::PATTERN,
        PatchToken::PATTERN,
        NumericToken::PATTERN,
        StringToken::PATTERN
      )
    ).map! do |token|
      case token
      when /\A#{AlphaToken::PATTERN}\z/o   then AlphaToken
      when /\A#{BetaToken::PATTERN}\z/o    then BetaToken
      when /\A#{RCToken::PATTERN}\z/o      then RCToken
      when /\A#{PatchToken::PATTERN}\z/o   then PatchToken
      when /\A#{NumericToken::PATTERN}\z/o then NumericToken
      when /\A#{StringToken::PATTERN}\z/o  then StringToken
      end.new(token)
    end
  end

  def self.parse spec
    version = _parse(spec)
    Version.new(version, true) unless version.nil?
  end

  def self._parse spec
    spec = Pathname.new(spec) unless spec.is_a? Pathname

    spec_s = spec.to_s

    stem = if spec.directory?
      spec.basename.to_s
    elsif %r[((?:sourceforge.net|sf.net)/.*)/download$].match(spec_s)
      Pathname.new(spec.dirname).stem
    else
      spec.stem
    end

    # GitHub tarballs
    # e.g. https://github.com/foo/bar/tarball/v1.2.3
    # e.g. https://github.com/sam-github/libnet/tarball/libnet-1.1.4
    # e.g. https://github.com/isaacs/npm/tarball/v0.2.5-1
    # e.g. https://github.com/petdance/ack/tarball/1.93_02
    m = %r[github.com/.+/(?:zip|tar)ball/(?:v|\w+-)?((?:\d+[-._])+\d*)$].match(spec_s)
    return m.captures.first unless m.nil?

    # e.g. https://github.com/erlang/otp/tarball/OTP_R15B01 (erlang style)
    m = /[-_]([Rr]\d+[AaBb]\d*(?:-\d+)?)/.match(spec_s)
    return m.captures.first unless m.nil?

    # e.g. boost_1_39_0
    m = /((?:\d+_)+\d+)$/.match(stem)
    return m.captures.first.gsub('_', '.') unless m.nil?

    # e.g. foobar-4.5.1-1
    # e.g. ruby-1.9.1-p243
    m = /-((?:\d+\.)*\d\.\d+-(?:p|rc|RC)?\d+)(?:[-._](?:bin|dist|stable|src|sources))?$/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. lame-398-1
    m = /-((?:\d)+-\d)/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. foobar-4.5.1
    m = /-((?:\d+\.)*\d+)$/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. foobar-4.5.1b
    m = /-((?:\d+\.)*\d+(?:[abc]|rc|RC)\d*)$/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. foobar-4.5.0-beta1, or foobar-4.50-beta
    m = /-((?:\d+\.)*\d+-beta\d*)$/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. foobar4.5.1
    m = /((?:\d+\.)*\d+)$/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. foobar-4.5.0-bin
    m = /-((?:\d+\.)+\d+[abc]?)[-._](?:bin|dist|stable|src|sources?)$/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. dash_0.5.5.1.orig.tar.gz (Debian style)
    m = /_((?:\d+\.)+\d+[abc]?)[.]orig$/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. http://www.openssl.org/source/openssl-0.9.8s.tar.gz
    m = /-v?([^-]+)/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. astyle_1.23_macosx.tar.gz
    m = /_([^_]+)/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. http://mirrors.jenkins-ci.org/war/1.486/jenkins.war
    m = /\/(\d\.\d+)\//.match(spec_s)
    return m.captures.first unless m.nil?

    # e.g. http://www.ijg.org/files/jpegsrc.v8d.tar.gz
    m = /\.v(\d+[a-z]?)/.match(stem)
    return m.captures.first unless m.nil?
  end
end

class VersionSchemeDetector
  def initialize scheme
    @scheme = scheme
  end

  def detect
    if @scheme.is_a? Class and @scheme.ancestors.include? Version
      @scheme
    elsif @scheme.is_a? Symbol then detect_from_symbol
    else
      raise "Unknown version scheme #{@scheme} was requested."
    end
  end

  private

  def detect_from_symbol
    raise "Unknown version scheme #{@scheme} was requested."
  end
end
