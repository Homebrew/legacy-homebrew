class Formula
  def self.md5(val)
    stable.md5(val)
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
    odie <<-EOS.undent
      MD5 support has been dropped for security reasons.
      Please switch this formula to SHA256.
    EOS
  end
end
