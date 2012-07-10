class Version
  include Comparable

  def initialize val
    return val if val.is_a? Version or val.nil?
    @version = val.to_s.strip
  end

  def nums
    @version.scan(/\d+/).map { |d| d.to_i }
  end

  def <=>(other)
    @version <=> other.version
  end

  def to_s
    @version
  end
  alias_method :to_str, :to_s

  def self.parse spec
    Pathname.new(spec.to_s).version
  end
end
