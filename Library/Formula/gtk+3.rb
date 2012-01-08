require 'formula'

class Gtkx3 < Formula
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/3.3/gtk+-3.3.6.tar.xz'
  homepage 'http://www.gtk.org/'
  sha256 'ae614b054fa313ae11400eb3446c5b83b41366885946b9375142536ee4944c16'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'gdk-pixbuf'
  depends_on 'pango'
  depends_on 'jasper' => :optional
  depends_on 'atk' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--disable-glibtest"
    system "make install"
  end

  def test
    system "#{bin}/gtk-demo"
  end
end
