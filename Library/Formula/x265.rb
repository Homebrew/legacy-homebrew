class X265 < Formula
  desc "H.265/HEVC encoder"
  homepage "http://x265.org"
  url "https://bitbucket.org/multicoreware/x265/downloads/x265_1.7.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/x/x265/x265_1.7.orig.tar.gz"
  sha256 "a52ca95e8e64219c1e8e73a9abf0bb7151ced2c93756a623cf2b7e5cf8226585"

  head "https://bitbucket.org/multicoreware/x265", :using => :hg

  bottle do
    cellar :any
    sha256 "d3070ceff18372d5ecdeac125c3fd0d61a6361589fea14fc8bf809ff4db2e01e" => :el_capitan
    sha256 "32ed5df4b757c9cda8e2233e0aaf81a81424417d5d0ae658520716a6cd317cd3" => :yosemite
    sha256 "4fbe6ec5800cfaeb839aafe7e79be6947f38293502ff130bab40e8915f8658f5" => :mavericks
    sha256 "804428e2dbeff3b3a92a73c4665c579012e4dbb2fd0218040004e7569fe13f29" => :mountain_lion
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
