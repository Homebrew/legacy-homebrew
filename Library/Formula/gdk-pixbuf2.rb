require 'formula'

class GdkPixbuf2 <Formula
  url 'ftp://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.22/gdk-pixbuf-2.22.1.tar.bz2'
  homepage 'http://www.gtk.org'
  sha256 '6ce87eda24af9362307b2593c154d0b660f4e26d0abf2e71d46d0ddd55fd953d'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
