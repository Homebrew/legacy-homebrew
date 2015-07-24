class Libbpg < Formula
  desc "Image format meant to improve on JPEG quality and file size"
  homepage "http://bellard.org/bpg/"
  url "http://bellard.org/bpg/libbpg-0.9.5.tar.gz"
  sha256 "30de1d0099920e24b7c9aae4d4e6b62f446823f0a1d52eb195dfc25c662ee203"

  bottle do
    cellar :any
    sha1 "b3484df329f2b40968a1d70f6a2b4e9df8b15c4d" => :yosemite
    sha1 "dc8a09cf7f7ebc452aa0d27caa78b4fb1d26b8c1" => :mavericks
    sha1 "ae5340b8b0a353282bafea08edce8146cf6d5106" => :mountain_lion
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
