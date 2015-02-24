require 'formula'

class Openslide < Formula
  homepage 'http://openslide.org/'
  url 'https://github.com/openslide/openslide/releases/download/v3.4.0/openslide-3.4.0.tar.gz'
  sha1 'edd28a142f7801a354949c05e7f1b7dcb246db6b'

  depends_on 'pkg-config' => :build
  depends_on 'libpng'
  depends_on 'jpeg'
  depends_on 'libxml2'
  depends_on 'libtiff'
  depends_on 'glib'
  depends_on 'openjpeg'
  depends_on 'cairo'
  depends_on 'gdk-pixbuf'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
