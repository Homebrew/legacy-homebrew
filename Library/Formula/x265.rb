require 'formula'

class X265 < Formula
  homepage 'http://x265.org'
  url 'https://bitbucket.org/multicoreware/x265/get/0.9.tar.bz2'
  sha1 'e387c4249571a9202b5a6c8f66aea37ee5106c48'

  bottle do
    cellar :any
    sha1 "52dc440a26f98ab3e1376639bf0f9ab9839ca571" => :mavericks
    sha1 "3279b91a78708542cc1f584feab4361675cb4473" => :mountain_lion
    sha1 "54caf21ff2db0fb9eeed41f7487063b960c7d74d" => :lion
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
