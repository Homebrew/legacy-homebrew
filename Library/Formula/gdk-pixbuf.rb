require 'formula'

class GdkPixbuf < Formula
  homepage 'http://gtk.org'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gdk-pixbuf/2.23/gdk-pixbuf-2.23.5.tar.bz2'
  md5 '025c38de1a599b0ded6c92d34924dd85'

  depends_on 'glib'
  depends_on 'jasper'
  depends_on 'libtiff'

  def options
    [
      ["--universal", "Builds a universal binary"]
    ]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libjasper",
                          "--enable-introspection=no"
    system "make install"
  end
end
