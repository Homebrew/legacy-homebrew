class Checksum
  attr_reader :hash_type, :hexdigest

  TYPES = [:md5, :sha1, :sha256]

  def initialize type=:sha1, val=nil
    @hash_type = type
    @hexdigest = val.to_s
  end

  def empty?
    @hexdigest.empty?
  end

  def to_s
    @hexdigest
  end

  def == other
    @hash_type == other.hash_type and @hexdigest == other.hexdigest
  end
end
