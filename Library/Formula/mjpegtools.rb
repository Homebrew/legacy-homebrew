require 'formula'

class Mjpegtools < Formula
  homepage 'http://mjpeg.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/mjpeg/mjpegtools/2.1.0/mjpegtools-2.1.0.tar.gz'
  sha1 'b9effa86280e23d67369e842e5cb645948583097'

  depends_on :x11 if MacOS::X11.installed?
  depends_on 'apple-gcc42' if MacOS.version >= :mountain_lion

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'libquicktime' => :optional
  depends_on 'libdv' => :optional
  depends_on 'gtk+' => :optional
  depends_on 'sdl_gfx' => :optional

  fails_with :clang do
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
