class Checksum
  attr_reader :hash_type, :hexdigest
  alias_method :to_s, :hexdigest

  TYPES = [:sha256]

  def initialize(hash_type, hexdigest)
    @hash_type = hash_type
    @hexdigest = hexdigest
  end

  def empty?
    hexdigest.empty?
  end

  def ==(other)
    hash_type == other.hash_type && hexdigest == other.hexdigest
  end
end
