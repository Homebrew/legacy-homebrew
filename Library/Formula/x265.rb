require 'formula'

class X265 < Formula
  homepage 'http://x265.org'
  url 'https://bitbucket.org/multicoreware/x265/get/1.1.tar.bz2'
  sha1 '57fc980cc2aabb43037ad29bc5201d3efcabff86'

  bottle do
    cellar :any
    sha1 "01b79d27daf72bb25fcd6bf3d18bda563f0257b4" => :mavericks
    sha1 "f9e0611e62f6787085a64d41ea74b23d208e31b1" => :mountain_lion
    sha1 "8f7c4b26b331c5ea6c052cc8bfa8622899c7c785" => :lion
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
