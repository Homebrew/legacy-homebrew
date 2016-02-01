class X265 < Formula
  desc "H.265/HEVC encoder"
  homepage "http://x265.org"
  url "https://bitbucket.org/multicoreware/x265/downloads/x265_1.9.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/x/x265/x265_1.9.orig.tar.gz"
  sha256 "3e4654133ed957a98708fdb4cb9a154d9e80922b84e26e43fc462a101c5b15c8"

  head "https://bitbucket.org/multicoreware/x265", :using => :hg

  bottle do
    cellar :any
    sha256 "6072f1038e151fd63ad5ba9e29ba90f98cf5697995af2ee10784d4dfaa9361bb" => :el_capitan
    sha256 "665b73272db7bf4d8e47b17c15cc858c78043987de5eec8a5cf3600b2c58550c" => :yosemite
    sha256 "d4dcbdd3119e0fdcf39dac6dc08d1beab14948ca3172bc5c00b9a64f157ec7bf" => :mavericks
  end

  option "with-16-bit", "Build a 16-bit x265 (default: 8-bit)"

  deprecated_option "16-bit" => "with-16-bit"

  depends_on "yasm" => :build
  depends_on "cmake" => :build
  depends_on :macos => :lion

  def install
    args = std_cmake_args
    args << "-DHIGH_BIT_DEPTH=ON" if build.with? "16-bit"

    system "cmake", "source", *args
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
