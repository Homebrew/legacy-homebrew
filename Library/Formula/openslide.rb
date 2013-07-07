require 'formula'

class Openslide < Formula
  homepage 'http://openslide.org/'
  url 'http://download.openslide.org/releases/openslide/openslide-3.3.2.tar.gz'
  sha1 '03c3fe32ef2a233a6f5bfe8f438587800751b326'

  depends_on 'pkg-config' => :build
  depends_on :libpng
  depends_on 'jpeg'
  depends_on 'libxml2'
  depends_on 'libtiff'
  depends_on 'glib'
  depends_on 'openjpeg'
  depends_on 'cairo'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
