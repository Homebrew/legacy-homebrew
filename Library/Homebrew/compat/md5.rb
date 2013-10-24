class Formula
  def self.md5(val)
    @stable ||= create_spec(SoftwareSpec)
    @stable.md5(val)
  end
end

class SoftwareSpec
  def md5(val)
    @resource.md5(val)
  end
end

class Resource
  def md5(val)
    @checksum = Checksum.new(:md5, val)
  end
end

class Pathname
  def md5
    require 'digest/md5'
    opoo <<-EOS.undent
    MD5 support is deprecated and will be removed in a future version.
    Please switch this formula to #{Checksum::TYPES.map { |t| t.to_s.upcase } * ' or '}.
    EOS
    incremental_hash(Digest::MD5)
  end
end
