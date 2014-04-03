require 'formula'

class Mjpegtools < Formula
  homepage 'http://mjpeg.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/mjpeg/mjpegtools/2.1.0/mjpegtools-2.1.0.tar.gz'
  sha1 'b9effa86280e23d67369e842e5cb645948583097'

  depends_on :x11 => :optional

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'libquicktime' => :optional
  depends_on 'libdv' => :optional
  depends_on 'gtk+' => :optional
  depends_on 'sdl_gfx' => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-simd-accel",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
