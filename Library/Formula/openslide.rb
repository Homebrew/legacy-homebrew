require 'formula'

class Openslide < Formula
  homepage 'http://openslide.org/'
  url 'http://download.openslide.org/releases/openslide/openslide-3.3.3.tar.gz'
  sha1 '2315f0daa5d963e6ba9f1e67517cee44f9deabe5'
  revision 1

  depends_on 'pkg-config' => :build
  depends_on 'libpng'
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
