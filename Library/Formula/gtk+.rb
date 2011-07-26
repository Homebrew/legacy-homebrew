require 'formula'

class Gtkx < Formula
  homepage 'http://www.gtk.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.5.tar.bz2'
  sha256 'f355f26003b1b42b97e584bdc475189a423fdd052088ee4bbd7aa0f989815cc8'

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
