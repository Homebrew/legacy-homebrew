require 'formula'

class Gtkx < Formula
  homepage 'http://www.gtk.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.8.tar.bz2'
  sha256 'ac2325a65312922a6722a7c02a389f3f4072d79e13131485cc7b7226e2537043'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'gdk-pixbuf'
  depends_on 'pango'
  depends_on 'jasper' => :optional
  depends_on 'atk' => :optional

  fails_with_llvm "Undefined symbols when linking", :build => "2326" unless MacOS.lion?

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-glibtest"
    system "make install"
  end

  def test
    system "#{bin}/gtk-demo"
  end
end
