require 'formula'

class Vips < Formula
  url 'http://www.vips.ecs.soton.ac.uk/supported/current/vips-7.24.7.tar.gz'
  head 'http://www.vips.ecs.soton.ac.uk/development/7.26/vips-7.26.0-beta.tar.gz'
  homepage 'http://www.vips.ecs.soton.ac.uk/'

  if ARGV.build_head?
    md5 '5ecd1a88d5026950b05333191953b77a'
  else
    md5 '559bca1168afe62d2ee76d51ad7c91a6'
  end

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
