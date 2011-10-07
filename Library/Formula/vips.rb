require 'formula'

class Vips < Formula
  url 'http://www.vips.ecs.soton.ac.uk/supported/current/vips-7.26.3.tar.gz'
  homepage 'http://www.vips.ecs.soton.ac.uk/'

  md5 '1fbf164ef0da8e835a036c56ff659e8e'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'jpeg' => :optional
  depends_on 'libtiff' => :optional
  depends_on 'imagemagick' => :optional
  depends_on 'fftw' => :optional
  depends_on 'little-cms' => :optional
  depends_on 'pango' => :optional
  depends_on 'libexif' => :optional
  depends_on 'liboil' => :optional
  depends_on 'openexr' => :optional

  def install
    ENV.x11 # for libpng
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
