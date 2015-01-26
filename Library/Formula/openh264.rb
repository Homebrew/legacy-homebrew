class Openh264 < Formula
  homepage "http://www.openh264.org"
  url "https://github.com/cisco/openh264/archive/v1.3.1.tar.gz"
  sha256 "b0a9a61840b4a58fbadd2a0640a81917c0ee84e922d2476c1dbcb9f29b85d7a0"
  head "https://github.com/cisco/openh264.git"

  bottle do
    cellar :any
    sha1 "18d43434ccf60b8e77deabc4fe14fa8d5f3b8dd0" => :yosemite
    sha1 "b846a0fca45ef3066904ce4ee12d3d2839bdb229" => :mavericks
    sha1 "3efc07638d0379c12cc832d18c263cb314a77f6b" => :mountain_lion
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
