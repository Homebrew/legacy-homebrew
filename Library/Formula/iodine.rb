require 'formula'

class Iodine < Formula
  url 'http://code.kryo.se/iodine/iodine-0.6.0-rc1.tar.gz'
  homepage 'http://code.kryo.se/iodine/'
  sha1 '4fa9a248b8a84df8a727a5d749e669e58136edca'

  def install
    unless MacOS.version == :leopard
      inreplace ["src/common.c", "src/dns.c", "src/iodine.c", "src/iodined.c"],
        "arpa/nameser8_compat", "arpa/nameser_compat"
    end

    system "make", "install", "prefix=#{prefix}"
  end
end
