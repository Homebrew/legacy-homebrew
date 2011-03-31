require 'formula'

class Gtkx < Formula
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.3.tar.bz2'
  homepage 'http://www.gtk.org/'
  sha256 '336ddf3dd342cc36bee80dd4f86ef036044a2deb10cda67c8eecf5315b279ef7'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'gdk-pixbuf'

  # Used by pango, but keg-only, so needs to be added to
  # the flags for gtk+ explicitly.
  depends_on 'cairo' if MACOS_VERSION < 10.6

  depends_on 'pango'
  depends_on 'jasper' => :optional
  depends_on 'atk' => :optional

  def install
    fails_with_llvm "Undefined symbols when linking", :build => "2326"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-glibtest"
    system "make install"
  end

  def test
    system "gtk-demo"
  end
end
