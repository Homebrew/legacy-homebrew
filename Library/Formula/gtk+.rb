require 'formula'

class Gtkx < Formula
  homepage 'http://www.gtk.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.4.tar.bz2'
  sha256 '7d3033ad83647079977466d3e8f1a7533f47abd5cc693f01b8797ff43dd407a5'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'gdk-pixbuf'

  # Used by pango, but keg-only, so needs to be added to
  # the flags for gtk+ explicitly.
  depends_on 'cairo' if MacOS.leopard?

  depends_on 'pango'
  depends_on 'jasper' => :optional
  depends_on 'atk' => :optional

  fails_with_llvm "Undefined symbols when linking", :build => "2326"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-glibtest"
    system "make install"
  end

  def test
    system "gtk-demo"
  end
end
