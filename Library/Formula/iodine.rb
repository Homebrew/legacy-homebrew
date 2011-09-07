require 'formula'

class Iodine < Formula
  url 'http://code.kryo.se/iodine/iodine-0.6.0-rc1.tar.gz'
  homepage 'http://code.kryo.se/iodine/'
  md5 'a15bb4faba020d217016fde6e231074a'

  def install
    unless MacOS.leopard?
      inreplace ["src/common.c", "src/dns.c", "src/iodine.c", "src/iodined.c"],
        "arpa/nameser8_compat", "arpa/nameser_compat"
    end

    system "make install prefix=#{prefix}"
  end
end
