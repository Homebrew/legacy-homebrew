require 'formula'

class GdkPixbuf < Formula
  homepage 'http://gtk.org'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gdk-pixbuf/2.24/gdk-pixbuf-2.24.0.tar.bz2'
  sha256 '38d2630314e6d91976bffd833236f84fefa440a9038f86dc422820a39f2e3700'

  depends_on 'glib'
  depends_on 'jasper'
  depends_on 'libtiff'

  def options
    [['--universal', 'Builds the library universal']]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    args = ["--prefix=#{prefix}",
            "--disable-dependency-tracking",
            "--disable-maintainer-mode",
            "--enable-debug=no",
            "--with-libjasper",
            "--enable-introspection=no",
            "--disable-Bsymbolic",
            "--without-gdiplus"]
    system "./configure", *args
    system "make"
    system "make install"
  end
end
