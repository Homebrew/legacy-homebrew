class Openh264 < Formula
  desc "H.264 codec from Cisco"
  homepage "http://www.openh264.org"
  url "https://github.com/cisco/openh264/archive/v1.5.0.tar.gz"
  sha256 "98077bd5d113c183ce02b678733b0cada2cf36750370579534c4d70f0b6c27b5"
  head "https://github.com/cisco/openh264.git"

  bottle do
    cellar :any
    sha256 "8094db937ecb3207efe8e51bb11bbf00940ca7032e2b12b7b1464ad24080c6bb" => :yosemite
    sha256 "c43513d0c9e3322c32ccd82f7030e5efaa17a78be8fae25422182ae3ed3c42c6" => :mavericks
    sha256 "488c57b64dda2e2f58b6b71527939f65f13fc052db6404608758e70004b29089" => :mountain_lion
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
