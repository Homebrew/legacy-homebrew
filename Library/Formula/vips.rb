require 'formula'

class Vips < Formula
  homepage 'http://www.vips.ecs.soton.ac.uk/'
  url 'http://www.vips.ecs.soton.ac.uk/supported/current/vips-7.28.0.tar.gz'
  md5 '16429e3b82d869936312c0a35faaf5d0'

  depends_on 'pkg-config' => :build
  depends_on :libpng
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
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
