require 'formula'

class X265 < Formula
  homepage 'http://x265.org'
  url 'https://bitbucket.org/multicoreware/x265/get/1.0.tar.bz2'
  sha1 '9e8de7d5b43320e637036b392da94d21cd70caae'

  bottle do
    cellar :any
    sha1 "61f6f7269e531b4d717cecd957ad717c877e318c" => :mavericks
    sha1 "f9d360cf34c403e9cdf74e330409a45c5c6327ef" => :mountain_lion
    sha1 "27e89872dd31e64c558a31d2faf20210b779f5e4" => :lion
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
    File.open(yuv_path, 'wb') do |f|
        (1..3200).each do f.write("\xCO\xFF\xEE") end
    end
    system "#{bin}/x265 --input-res 80x80 --fps 1 #{yuv_path} #{x265_path}"
    header = 'AAAAAUABDAH//w=='
    assert_equal header.unpack("m"), [x265_path.read(10)]
    end
end
