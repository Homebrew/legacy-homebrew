require 'formula'

class Mjpegtools < Formula
  homepage 'http://mjpeg.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/mjpeg/mjpegtools/2.0.0/mjpegtools-2.0.0.tar.gz'
  sha1 'f411e8573d446711dbe8455a6ae9257e1afe1e70'

  option "with-libquicktime", "Build with Quicktime support"
  option "with-libdv", "Build with DV support"
  option "with-gtk+", "Build with GTK+ support"
  option "with-sdl_gfx", "Build with SDL support"

  depends_on 'jpeg'
  depends_on 'libquicktime' => :optional if build.include? "with-libquicktime"
  depends_on 'libdv' => :optional if build.include? "with-libdv"
  depends_on 'gtk+' => :optional if build.include? "with-gtk+"
  depends_on 'sdl_gfx' => :optional if build.include? "with-sdl_gfx"

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      In file included from newdenoise.cc:19:
      ./MotionSearcher.hh:2199:3: error: use of undeclared identifier 'DeleteRegion'
    EOS
  end

  def install
    args = ["--disable-dependency-tracking",
            "--enable-simd-accel",
            "--prefix=#{prefix}"]

    system "./configure", *args
    system "make install"
  end
end
