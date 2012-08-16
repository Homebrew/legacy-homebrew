require 'formula'

class Gtkx3 < Formula
  homepage 'http://gtk.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/3.4/gtk+-3.4.4.tar.xz'
  sha256 'f154e460075034da4c0ce89c320025dcd459da2a1fdf32d92a09522eaca242c7'

  depends_on :x11 => '2.5' # needs XInput2, introduced in libXi 1.3
  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'gdk-pixbuf'
  depends_on 'pango'
  depends_on 'cairo' # for cairo-gobject; XQuartz includes it, but it's broken as of 2.7.2
  depends_on 'jasper' => :optional
  depends_on 'atk' => :optional

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-introspection"
    system "make install"
  end

  def test
    system "#{bin}/gtk3-demo"
  end
end
