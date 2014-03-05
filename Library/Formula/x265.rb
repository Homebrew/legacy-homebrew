require 'formula'

class X265 < Formula
  homepage 'http://x265.org'
  url 'https://bitbucket.org/multicoreware/x265/get/0.8.tar.bz2'
  sha1 '79c60b3fe528e7b91b799b85e971885c1b040b6e'

  bottle do
    cellar :any
    sha1 "1d3a8f05eb2994290fd08b9a42a84c5db3561e42" => :mavericks
    sha1 "810c333f3d71f73e69b6ac6e391464eb7259c601" => :mountain_lion
    sha1 "518b8997f9f7707a3079f76d24b3e0075eaa8ea5" => :lion
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
    header = 'AAAAAUABDAH//wFgAAADAIAAAAMAAAMAHpXA'
    assert_equal header.unpack("m"), [x265_path.read(27)]
    end
end
