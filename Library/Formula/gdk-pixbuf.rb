require 'formula'

class GdkPixbuf < Formula
  homepage 'http://gtk.org'
  url 'http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.22/gdk-pixbuf-2.22.1.tar.bz2'
  md5 '716c4593ead3f9c8cca63b8b1907a561'

  depends_on 'glib'
  depends_on 'jasper'
  depends_on 'libtiff'

  def install
    # added the missing path for PKGCONFIG to find glib-2.0.pc, unfortunately
      # I don't know the way to specify the prefix path for another formula,
      # this is a bit hack-ish way of fixing it.
    ENV['PKG_CONFIG_PATH'] = "#{HOMEBREW_PREFIX}/Cellar/glib/2.28.6/lib/pkgconfig"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libjasper",
                          "--enable-introspection=no"
    system "make install"
  end
end
