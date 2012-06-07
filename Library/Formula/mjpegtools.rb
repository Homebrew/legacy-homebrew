require 'formula'

class Mjpegtools < Formula
  homepage 'http://mjpeg.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/mjpeg/mjpegtools/2.0.0/mjpegtools-2.0.0.tar.gz'
  md5 '903e1e3b967eebcc5fe5626d7517dc46'

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on :x11
  depends_on 'libquicktime' => :optional
  depends_on 'libdv' => :optional
  depends_on 'gtk+' => :optional
  depends_on 'sdl_gfx' => :optional

  # binaries will fail with missing symbol errors when stripped
  skip_clean ['bin']

  def options
    [["--without-x", "Build without X support"]]
  end

  fails_with :clang do
    build 318
    cause <<-EOS.undent
      In file included from newdenoise.cc:19:
      ./MotionSearcher.hh:2199:3: error: use of undeclared identifier 'DeleteRegion'
    EOS
  end

  def install
    args = ["--disable-dependency-tracking",
            "--enable-simd-accel",
            "--prefix=#{prefix}"]
    args << "--without-x" if ARGV.include? "--without-x"

    system "./configure", *args
    system "make install"
  end
end
