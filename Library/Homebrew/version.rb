class Version
  include Comparable

  def initialize val, detected=false
    return val if val.is_a? Version or val.nil?
    @version = val.to_s
    @detected_from_url = detected
  end

  def detected_from_url?
    @detected_from_url
  end

  def head?
    @version == 'HEAD'
  end

  def nums
    @version.scan(/\d+/).map { |d| d.to_i }
  end

  def <=>(other)
    return nil unless other.is_a? Version
    return 0 if self.head? and other.head?
    return 1 if self.head? and not other.head?
    return -1 if not self.head? and other.head?
    return 1 if other.nil?

    snums = self.nums
    onums = other.nums

    count = [snums.length, onums.length].max

    snums.fill(0, snums.length, count - snums.length)
    onums.fill(0, onums.length, count - onums.length)

    snums <=> onums
  end

  def to_s
    @version
  end
  alias_method :to_str, :to_s

  def self.parse spec
    version = _parse(spec)
    Version.new(version, true) unless version.nil?
  end

  private

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

    # e.g. boost_1_39_0
    m = /((\d+_)+\d+)$/.match(stem)
    return m.captures.first.gsub('_', '.') unless m.nil?

    # e.g. foobar-4.5.1-1
    # e.g. ruby-1.9.1-p243
    m = /-((\d+\.)*\d\.\d+-(p|rc|RC)?\d+)$/.match(stem)
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

    # e.g. erlang-R14B03-bottle.tar.gz (old erlang bottle style)
    m = /-([^-]+)/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. opt_src_R13B (erlang)
    m = /otp_src_(.+)/.match(stem)
    return m.captures.first unless m.nil?

    # e.g. astyle_1.23_macosx.tar.gz
    m = /_([^_]+)/.match(stem)
    return m.captures.first unless m.nil?
  end

  # DSL for defining comparators
  class << self
    def compare &blk
      send(:define_method, '<=>', &blk)
    end
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
