require "formula"

class Openh264 < Formula
  homepage "http://www.openh264.org"
  url "https://github.com/cisco/openh264/archive/v1.1.tar.gz"
  sha256 "d1d8e0087adfd372c22fd84746092a04627355468e70420451b2c2dbd4c37699"
  head "https://github.com/cisco/openh264.git"

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
