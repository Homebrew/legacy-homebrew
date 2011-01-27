require 'formula'

class Iodine <Formula
  url 'http://code.kryo.se/iodine/iodine-0.5.2.tar.gz'
  homepage 'http://code.kryo.se/iodine/'
  md5 '6952343cc4614857f83dbb81247871e7'

  def install
    if MACOS_VERSION >= 10.6
      inreplace ["src/common.c", "src/dns.c", "src/iodine.c", "src/iodined.c"],
        "arpa/nameser8_compat", "arpa/nameser_compat"
    end

    system "make install prefix=#{prefix}"
  end
end
