require 'formula'

class Vips < Formula
  url 'http://www.vips.ecs.soton.ac.uk/supported/7.20/vips-7.20.7.tar.gz'
  head 'http://www.vips.ecs.soton.ac.uk/supported/7.22/vips-7.22.2.tar.gz'
  homepage 'http://www.vips.ecs.soton.ac.uk/'

  if ARGV.build_head?
    md5 'bb626458e82ff208ea531c304f65cb04'
  else
    md5 '6323a1311a0e7b544cea407d88b82e93'
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
