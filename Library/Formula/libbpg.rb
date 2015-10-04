class Libbpg < Formula
  desc "Image format meant to improve on JPEG quality and file size"
  homepage "http://bellard.org/bpg/"
  url "http://bellard.org/bpg/libbpg-0.9.5.tar.gz"
  sha256 "30de1d0099920e24b7c9aae4d4e6b62f446823f0a1d52eb195dfc25c662ee203"

  bottle do
    cellar :any
    revision 1
    sha256 "02a25cb0b5672e5a78b8439bce4016341229fca8902042263090a3f72ef29aba" => :yosemite
    sha256 "03f7fd9e4785c4d024c00d686680e3e06cd331379578e24151b853215446fa68" => :mavericks
    sha256 "8a052c59fc6881292eb00deb01d4c6a5dd01a7ce7ff58c821ea3e8dc2278b1c4" => :mountain_lion
  end

  option "with-x265", "Enable x265 encoder"
  option "without-jctvc", "Disable built-in JCTVC encoder"

  depends_on "libpng"
  depends_on "jpeg"
  depends_on "x265" => :optional

  def install
    bin.mkpath
    args = []
    args << "USE_X265=y" if build.with? "x265"
    args << "USE_JCTVC=" if build.without? "jctvc"
    system "make", "install", "prefix=#{prefix}", "CONFIG_APPLE=y", *args
  end

  test do
    system "#{bin}/bpgenc", test_fixtures("test.png")
  end
end
