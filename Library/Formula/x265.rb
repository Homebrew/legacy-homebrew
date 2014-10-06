require 'formula'

class X265 < Formula
  homepage "http://x265.org"
  url "https://bitbucket.org/multicoreware/x265/get/1.3.tar.bz2"
  sha1 "b24fc768c61bab3dc4442dc65649fa74d16318a2"

  bottle do
    cellar :any
    sha1 "916d54e01a0033717e32b6bef0ab1fe5e8dbe1a9" => :mavericks
    sha1 "c4179415d4281ca5512f2fa532236dc6178929fb" => :mountain_lion
    sha1 "0b0f9bc016fa0a214097850742cd02891309d3a2" => :lion
  end

  head 'https://bitbucket.org/multicoreware/x265', :using => :hg

  depends_on 'yasm' => :build
  depends_on 'cmake' => :build
  depends_on :macos => :lion

  option '16-bit', 'Build a 16-bit x265 (default: 8-bit)'

  def install

    args = std_cmake_args
    args.delete '-DCMAKE_BUILD_TYPE=None'
    args << '-DCMAKE_BUILD_TYPE=Release'
    args << '-DHIGH_BIT_DEPTH=ON' if build.include? '16-bit'

    system "cmake", "source",  *args
    system "make", "install"
  end

  test do
    yuv_path = testpath/"raw.yuv"
    x265_path = testpath/"x265.265"
    yuv_path.binwrite "\xCO\xFF\xEE" * 3200
    system "#{bin}/x265 --input-res 80x80 --fps 1 #{yuv_path} #{x265_path}"
    header = 'AAAAAUABDAH//w=='
    assert_equal header.unpack("m"), [x265_path.read(10)]
  end
end
