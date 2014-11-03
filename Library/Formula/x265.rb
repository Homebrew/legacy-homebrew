require 'formula'

class X265 < Formula
  homepage "http://x265.org"
  url "https://bitbucket.org/multicoreware/x265/get/1.4.tar.bz2"
  sha1 "95b4481d61d1766fce4b7120d4b49d08e39d922b"

  bottle do
    cellar :any
    sha1 "e01e498d5bcd69391d2ac68ce0f507c1aec71b4f" => :yosemite
    sha1 "b25757d40934c1d49d183f71dde41ade71563ea0" => :mavericks
    sha1 "41905d7b570e7e2be6d4fd99f641b5549a8e7719" => :mountain_lion
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
