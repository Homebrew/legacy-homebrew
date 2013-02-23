require 'formula'

class Mjpegtools < Formula
  homepage 'http://mjpeg.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/mjpeg/mjpegtools/2.0.0/mjpegtools-2.0.0.tar.gz'
  sha1 'f411e8573d446711dbe8455a6ae9257e1afe1e70'

  depends_on :x11 if MacOS::X11.installed?

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'libquicktime' => :optional
  depends_on 'libdv' => :optional
  depends_on 'gtk+' => :optional
  depends_on 'sdl_gfx' => :optional

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      In file included from newdenoise.cc:19:
      ./MotionSearcher.hh:2199:3: error: use of undeclared identifier 'DeleteRegion'
    EOS
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-simd-accel",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
