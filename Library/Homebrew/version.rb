class VersionElement
  include Comparable

  def initialize elem
    elem = elem.to_s.downcase
    @elem = case elem
      when 'a', 'alpha' then 'alpha'
      when 'b', 'beta' then 'beta'
      when /\d+/ then elem.to_i
      else elem
      end
  end

  def <=>(other)
    return unless other.is_a? VersionElement
    return -1 if string? and other.numeric?
    return 1 if numeric? and other.string?
    return elem <=> other.elem
  end

  def to_s
    @elem.to_s
  end

  protected

  attr_reader :elem

  def string?
    elem.is_a? String
  end

  def numeric?
    elem.is_a? Numeric
  end
end

class Version
  include Comparable

  def initialize val, detected=false
    @version = val.to_s
    @detected_from_url = detected
  end

  def detected_from_url?
    @detected_from_url
  end

  def head?
    @version == 'HEAD'
  end

  def devel?
    alpha? or beta? or rc?
  end

  def alpha?
    to_a.any? { |e| e.to_s == 'alpha' }
  end

  def beta?
    to_a.any? { |e| e.to_s == 'beta' }
  end

  def rc?
    to_a.any? { |e| e.to_s == 'rc' }
  end

  def <=>(other)
    # Return nil if objects aren't comparable
    return unless other.is_a? Version
    # Versions are equal if both are HEAD
    return  0 if head? and other.head?
    # HEAD is greater than any numerical version
    return  1 if head? and not other.head?
    return -1 if not head? and other.head?

    stuple, otuple = to_a, other.to_a

    max = [stuple.length, otuple.length].max

    stuple.fill(VersionElement.new(0), stuple.length, max - stuple.length)
    otuple.fill(VersionElement.new(0), otuple.length, max - otuple.length)

    stuple <=> otuple
  end

  def to_s
    @version
  end
  alias_method :to_str, :to_s

  protected

  def to_a
    @array ||= @version.scan(/\d+|[a-zA-Z]+/).map { |e| VersionElement.new(e) }
  end

  def self.parse spec
    version = _parse(spec)
    Version.new(version, true) unless version.nil?
  end

  def self._parse spec
    spec = Pathname.new(spec) unless spec.is_a? Pathname

    stem = if spec.directory?
      spec.basename.to_s
    elsif %r[((?:sourceforge.net|sf.net)/.*)/download$].match(spec.to_s)
      Pathname.new(spec.dirname).stem
    else
      spec.stem
    end

    # GitHub tarballs, e.g. v1.2.3
    m = %r[github.com/.+/(?:zip|tar)ball/v?((\d+\.)+\d+)$].match(spec.to_s)
    return m.captures.first unless m.nil?

    # e.g. https://github.com/sam-github/libnet/tarball/libnet-1.1.4
    m = %r[github.com/.+/(?:zip|tar)ball/.*-((\d+\.)+\d+)$].match(spec.to_s)
    return m.captures.first unless m.nil?

    # e.g. https://github.com/isaacs/npm/tarball/v0.2.5-1
    m = %r[github.com/.+/(?:zip|tar)ball/v?((\d+\.)+\d+-(\d+))$].match(spec.to_s)
    return m.captures.first unless m.nil?

    # e.g. https://github.com/petdance/ack/tarball/1.93_02
    m = %r[github.com/.+/(?:zip|tar)ball/v?((\d+\.)+\d+_(\d+))$].match(spec.to_s)
    return m.captures.first unless m.nil?

    # e.g. https://github.com/erlang/otp/tarball/OTP_R15B01 (erlang style)
    m = /[-_](R\d+[AB]\d*(-\d+)?)/.match(spec.to_s)
    return m.captures.first unless m.nil?

    # e.g. boost_1_39_0
    m = /((\d+_)+\d+)$/.match(stem)
    return m.captures.first.gsub('_', '.') unless m.nil?

    # e.g. foobar-4.5.1-1
    # e.g. ruby-1.9.1-p243
    m = /-((\d+\.)*\d\.\d+-(p|rc|RC)?\d+)(?:[-._](?:bin|dist|stable|src|sources))?$/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. lame-398-1
    m = /-((\d)+-\d)/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. foobar-4.5.1
    m = /-((\d+\.)*\d+)$/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. foobar-4.5.1b
    m = /-((\d+\.)*\d+([abc]|rc|RC)\d*)$/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. foobar-4.5.0-beta1, or foobar-4.50-beta
    m = /-((\d+\.)*\d+-beta(\d+)?)$/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. foobar4.5.1
    m = /((\d+\.)*\d+)$/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. foobar-4.5.0-bin
    m = /-((\d+\.)+\d+[abc]?)[-._](bin|dist|stable|src|sources?)$/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. dash_0.5.5.1.orig.tar.gz (Debian style)
    m = /_((\d+\.)+\d+[abc]?)[.]orig$/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. http://www.openssl.org/source/openssl-0.9.8s.tar.gz
    m = /-([^-]+)/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. astyle_1.23_macosx.tar.gz
    m = /_([^_]+)/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. http://mirrors.jenkins-ci.org/war/1.486/jenkins.war
    m = /\/(\d\.\d+)\//.match(spec.to_s)
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
