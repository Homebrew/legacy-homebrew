class Version
  include Comparable

  def initialize val
    return val if val.is_a? Version or val.nil?
    @version = val.to_s.strip
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
    Pathname.new(spec.to_s).version
  end
end
