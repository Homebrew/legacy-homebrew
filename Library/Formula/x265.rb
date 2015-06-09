class X265 < Formula
  desc "H.265/HEVC encoder"
  homepage "http://x265.org"
  url "https://bitbucket.org/multicoreware/x265/downloads/x265_1.7.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/x/x265/x265_1.7.orig.tar.gz"
  sha256 "a52ca95e8e64219c1e8e73a9abf0bb7151ced2c93756a623cf2b7e5cf8226585"

  head "https://bitbucket.org/multicoreware/x265", :using => :hg

  bottle do
    cellar :any
    sha256 "590e84fcd72593be8c8dc69881b4da0c59c1a265ac71bc5f7a28fa4351c8f150" => :yosemite
    sha256 "769b1041601bbeecadae13acc221558d6104b017bf034fe28ee7ed863fc1996e" => :mavericks
    sha256 "440805e02452b80400ff428967bd4c5d24f042bea2cc6b5d76a3a37648965a60" => :mountain_lion
  end

  option "with-16-bit", "Build a 16-bit x265 (default: 8-bit)"

  deprecated_option "16-bit" => "with-16-bit"

  depends_on "yasm" => :build
  depends_on "cmake" => :build
  depends_on :macos => :lion

  def install
    args = std_cmake_args
    args << "-DHIGH_BIT_DEPTH=ON" if build.with? "16-bit"

    system "cmake", "source",  *args
    system "make", "install"
  end

  test do
    yuv_path = testpath/"raw.yuv"
    x265_path = testpath/"x265.265"
    yuv_path.binwrite "\xCO\xFF\xEE" * 3200
    system bin/"x265", "--input-res", "80x80", "--fps", "1", yuv_path, x265_path
    header = "AAAAAUABDAH//w=="
    assert_equal header.unpack("m"), [x265_path.read(10)]
  end
end
