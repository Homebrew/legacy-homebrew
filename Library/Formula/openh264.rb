class Openh264 < Formula
  desc "H.264 codec from Cisco"
  homepage "http://www.openh264.org"
  url "https://github.com/cisco/openh264/archive/v1.3.1.tar.gz"
  sha256 "b0a9a61840b4a58fbadd2a0640a81917c0ee84e922d2476c1dbcb9f29b85d7a0"
  head "https://github.com/cisco/openh264.git"

  bottle do
    cellar :any
    sha1 "582bf09f67c1c1f6cb775e9fcff3ea8f1d8dc482" => :yosemite
    sha1 "44136761ff774546fb4ef571d38712edc5e5e0a2" => :mavericks
    sha1 "2a464bb129406b2ee227c63720bef8b2235a9910" => :mountain_lion
  end

  depends_on "nasm" => :build

  def install
    system "make", "install-shared", "PREFIX=#{prefix}"
    chmod 0444, "#{lib}/libopenh264.dylib"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <wels/codec_api.h>
      int main() {
        ISVCDecoder *dec;
        WelsCreateDecoder (&dec);
        WelsDestroyDecoder (dec);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lopenh264", "-o", "test"
    system "./test"
  end
end
