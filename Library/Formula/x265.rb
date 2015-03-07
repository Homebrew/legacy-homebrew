require 'formula'

class X265 < Formula
  homepage "http://x265.org"
  url "https://bitbucket.org/multicoreware/x265/get/1.5.tar.bz2"
  sha1 "a348aca6aca873728607f28fa69428ae28b19bd0"

  bottle do
    cellar :any
    sha1 "f69792c6c8480493a77adb1350cfe7af4f3521d0" => :yosemite
    sha1 "3de7b579f0c0ee874b1ce9d060ff270a46aab930" => :mavericks
    sha1 "4c46671953cdbd0d72b977028162d796521bbf15" => :mountain_lion
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
