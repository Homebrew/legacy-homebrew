class Formula
  def self.sha1(val)
    stable.sha1(val)
  end
end

class SoftwareSpec
  def sha1(val)
    @resource.sha1(val)
  end
end

class Resource
  def sha1(val)
    @checksum = Checksum.new(:sha1, val)
  end
end

class BottleSpecification
  def sha1(val)
    digest, tag = val.shift
    collector[tag] = Checksum.new(:sha1, digest)
  end
end

class Pathname
  def sha1
    require "digest/sha1"
    opoo <<-EOS.undent
    SHA1 support is deprecated and will be removed in a future version.
    Please switch this formula to SHA256.
    EOS
    incremental_hash(Digest::SHA1)
  end
end
