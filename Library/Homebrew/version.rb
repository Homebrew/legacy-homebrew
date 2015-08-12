class Version
  include Comparable

  class Token
    include Comparable

    attr_reader :value

    def initialize(value)
      @value = value
    end

    def inspect
      "#<#{self.class.name} #{value.inspect}>"
    end

    def to_s
      value.to_s
    end

    def numeric?
      false
    end
  end

  class NullToken < Token
    def initialize(value = nil)
      super
    end

    def <=>(other)
      case other
      when NullToken
        0
      when NumericToken
        other.value == 0 ? 0 : -1
      when AlphaToken, BetaToken, RCToken
        1
      else
        -1
      end
    end

    def inspect
      "#<#{self.class.name}>"
    end
  end

  NULL_TOKEN = NullToken.new

  class StringToken < Token
    PATTERN = /[a-z]+[0-9]*/i

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

    def numeric?
      true
    end
  end

  class CompositeToken < StringToken
    def rev
      value[/[0-9]+/].to_i
    end
  end

  class AlphaToken < CompositeToken
    PATTERN = /a(?:lpha)?[0-9]*/i

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
    PATTERN = /b(?:eta)?[0-9]*/i

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
    PATTERN = /rc[0-9]*/i

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
    PATTERN = /p[0-9]*/i

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

  SCAN_PATTERN = Regexp.union(
    AlphaToken::PATTERN,
    BetaToken::PATTERN,
    RCToken::PATTERN,
    PatchToken::PATTERN,
    NumericToken::PATTERN,
    StringToken::PATTERN
  )

  class FromURL < Version
    def detected_from_url?
      true
    end
  end

  def self.detect(url, specs)
    if specs.key?(:tag)
      FromURL.new(specs[:tag][/((?:\d+\.)*\d+)/, 1])
    else
      FromURL.parse(url)
    end
  end

  def initialize(val)
    if val.respond_to?(:to_str)
      @version = val.to_str
    else
      raise TypeError, "Version value must be a string"
    end
  end

  def detected_from_url?
    false
  end

  def head?
    version == "HEAD"
  end

  def <=>(other)
    return unless Version === other
    return 0 if version == other.version
    return 1 if head? && !other.head?
    return -1 if !head? && other.head?

    ltokens = tokens
    rtokens = other.tokens
    max = max(ltokens.length, rtokens.length)
    l = r = 0

    while l < max
      a = ltokens[l] || NULL_TOKEN
      b = rtokens[r] || NULL_TOKEN

      if a == b
        l += 1
        r += 1
        next
      elsif a.numeric? && b.numeric?
        return a <=> b
      elsif a.numeric?
        return 1 if a > NULL_TOKEN
        l += 1
      elsif b.numeric?
        return -1 if b > NULL_TOKEN
        r += 1
      else
        return a <=> b
      end
    end

    0
  end
  alias_method :eql?, :==

  def hash
    version.hash
  end

  def to_s
    version.dup
  end
  alias_method :to_str, :to_s

  protected

  attr_reader :version

  def tokens
    @tokens ||= tokenize
  end

  private

  def max(a, b)
    a > b ? a : b
  end

  def tokenize
    version.scan(SCAN_PATTERN).map! do |token|
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

  def self.parse(spec)
    version = _parse(spec)
    new(version) unless version.nil?
  end

  def self._parse(spec)
    spec = Pathname.new(spec) unless spec.is_a? Pathname

    spec_s = spec.to_s

    stem = if spec.directory?
      spec.basename.to_s
    elsif %r{((?:sourceforge.net|sf.net)/.*)/download$}.match(spec_s)
      Pathname.new(spec.dirname).stem
    else
      spec.stem
    end

    # GitHub tarballs
    # e.g. https://github.com/foo/bar/tarball/v1.2.3
    # e.g. https://github.com/sam-github/libnet/tarball/libnet-1.1.4
    # e.g. https://github.com/isaacs/npm/tarball/v0.2.5-1
    # e.g. https://github.com/petdance/ack/tarball/1.93_02
    m = %r{github.com/.+/(?:zip|tar)ball/(?:v|\w+-)?((?:\d+[-._])+\d*)$}.match(spec_s)
    return m.captures.first unless m.nil?

    # e.g. https://github.com/erlang/otp/tarball/OTP_R15B01 (erlang style)
    m = /[-_]([Rr]\d+[AaBb]\d*(?:-\d+)?)/.match(spec_s)
    return m.captures.first unless m.nil?

    # e.g. boost_1_39_0
    m = /((?:\d+_)+\d+)$/.match(stem)
    return m.captures.first.tr("_", ".") unless m.nil?

    # e.g. foobar-4.5.1-1
    # e.g. unrtf_0.20.4-1
    # e.g. ruby-1.9.1-p243
    m = /[-_]((?:\d+\.)*\d\.\d+-(?:p|rc|RC)?\d+)(?:[-._](?:bin|dist|stable|src|sources))?$/.match(stem)
    return m.captures.first unless m.nil?

    # URL with no extension
    # e.g. https://waf.io/waf-1.8.12
    # e.g. https://codeload.github.com/gsamokovarov/jump/tar.gz/v0.7.1
    m = /[-v]((?:\d+\.)*\d+)$/.match(spec_s)
    return m.captures.first unless m.nil?

    # e.g. lame-398-1
    m = /-((?:\d)+-\d+)/.match(stem)
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

    # e.g. http://ftpmirror.gnu.org/libidn/libidn-1.29-win64.zip
    # e.g. http://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.17-w32.zip
    m = /-(\d+\.\d+(?:\.\d+)?)-w(?:in)?(?:32|64)$/.match(stem)
    return m.captures.first unless m.nil?

    # Opam packages
    # e.g. https://opam.ocaml.org/archives/sha.1.9+opam.tar.gz
    # e.g. https://opam.ocaml.org/archives/lablgtk.2.18.3+opam.tar.gz
    # e.g. https://opam.ocaml.org/archives/easy-format.1.0.2+opam.tar.gz
    m = /\.(\d+\.\d+(?:\.\d+)?)\+opam$/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. http://ftpmirror.gnu.org/mtools/mtools-4.0.18-1.i686.rpm
    # e.g. http://ftpmirror.gnu.org/autogen/autogen-5.5.7-5.i386.rpm
    # e.g. http://ftpmirror.gnu.org/libtasn1/libtasn1-2.8-x86.zip
    # e.g. http://ftpmirror.gnu.org/libtasn1/libtasn1-2.8-x64.zip
    # e.g. http://ftpmirror.gnu.org/mtools/mtools_4.0.18_i386.deb
    m = /[-_](\d+\.\d+(?:\.\d+)?(?:-\d+)?)[-_.](?:i[36]86|x86|x64(?:[-_](?:32|64))?)$/.match(stem)
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

    # e.g. https://www.openssl.org/source/openssl-0.9.8s.tar.gz
    m = /-v?([^-]+)/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. astyle_1.23_macosx.tar.gz
    m = /_([^_]+)/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. http://mirrors.jenkins-ci.org/war/1.486/jenkins.war
    # e.g. https://github.com/foo/bar/releases/download/0.10.11/bar.phar
    m = /\/(\d\.\d+(\.\d+)?)\//.match(spec_s)
    return m.captures.first unless m.nil?

    # e.g. http://www.ijg.org/files/jpegsrc.v8d.tar.gz
    m = /\.v(\d+[a-z]?)/.match(stem)
    return m.captures.first unless m.nil?
  end
end
