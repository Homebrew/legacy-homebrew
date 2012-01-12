require 'formula'

class Mjpegtools < Formula
  url 'http://downloads.sourceforge.net/project/mjpeg/mjpegtools/2.0.0/mjpegtools-2.0.0.tar.gz'
  homepage 'http://mjpeg.sourceforge.net/'
  md5 '903e1e3b967eebcc5fe5626d7517dc46'

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'libquicktime' => :optional
  depends_on 'libdv' => :optional
  depends_on 'gtk+' => :optional
  depends_on 'sdl_gfx' => :optional

  # mjpegtools's binaries will fail with missing symbol errors
  # when stripped
  skip_clean ['bin']

  def options
    [
      ["--without-x", "Build without X support"]
    ]
  end

  def install
    ENV.x11
    args = ["--disable-dependency-tracking",
            "--enable-simd-accel",
            "--prefix=#{prefix}"]
    args << "--without-x" if ARGV.include? "--without-x"

    system "./configure", *args
    system "make install"
  end
end
