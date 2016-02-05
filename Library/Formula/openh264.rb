class Openh264 < Formula
  desc "H.264 codec from Cisco"
  homepage "http://www.openh264.org"
  url "https://github.com/cisco/openh264/archive/v1.5.0.tar.gz"
  sha256 "98077bd5d113c183ce02b678733b0cada2cf36750370579534c4d70f0b6c27b5"
  head "https://github.com/cisco/openh264.git"

  bottle do
    cellar :any
    sha256 "424ff1307edceda5ac26df93bbd689b39ff1abb8ccbcbfa160bac5d95ae9a2dd" => :el_capitan
    sha256 "1b7af220ac4bba224ef15271d25b5204c96ac7f727b2250628813233dac96239" => :yosemite
    sha256 "e6049b768ce933f23a84634ae84e31b02a3bdb81b9e1d30250ca207a193861a0" => :mavericks
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
