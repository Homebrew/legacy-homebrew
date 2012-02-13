require 'formula'

class GdkPixbuf < Formula
  homepage 'http://gtk.org'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gdk-pixbuf/2.24/gdk-pixbuf-2.24.1.tar.xz'
  sha256 'da7a3f00db360913716368e19e336402755cafa93769f3cfa28a969303e4bee1'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'jasper'
  depends_on 'libtiff'

  def options
    [["--universal", "Build a universal binary."]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-maintainer-mode",
                          "--enable-debug=no",
                          "--prefix=#{prefix}",
                          "--with-libjasper",
                          "--enable-introspection=no",
                          "--disable-Bsymbolic",
                          "--without-gdiplus"
    system "make"
    system "make install"
  end
end
