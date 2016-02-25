class I2util < Formula
  desc "Internet2 utility tools"
  homepage "http://software.internet2.edu/"
  url "http://software.internet2.edu/sources/I2util/I2util-1.2.tar.gz"
  sha256 "3b704cdb88e83f7123f3cec0fe3283b0681cc9f80c426c3f761a0eefd1d72c59"

  bottle do
    cellar :any_skip_relocation
    sha256 "44f87d48502ae3e34ebfc0882aa689a70e8c92d398247c5a53e2f4b7d7652b39" => :el_capitan
    sha256 "ad1821b2637c75638de2ecd2bd3127a0c8300fe4fbd72c18ae648a131b97b6f7" => :yosemite
    sha256 "b9a22dff1f4a26be02712d17de832a23fc3dbe5eee75ab62b72ffb5b18ecbd99" => :mavericks
    sha256 "9f65e87b0ac438c0d5b635e599303d54b9024458ca4ef21fe7a65a7f013595c2" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <I2util/util.h>
      #include <string.h>
      int main() {
        uint8_t buf[2];
        if (!I2HexDecode("beef", buf, sizeof(buf))) return 1;
        if (buf[0] != 190 || buf[1] != 239) return 1;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lI2util", "-o", "test"
    system "./test"
  end
end
