require 'formula'

class Gtkx <Formula
  url 'ftp://ftp.gnome.org/pub/gnome/sources/gtk+/2.22/gtk+-2.22.0.tar.bz2'
  homepage 'http://www.gtk.org/'
  sha256 'd9522c80d4b8a954f7474e32bd5a99ba3051996f1c4681426db5f79a1c1b4602'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'

  # Used by pango, but keg-only, so needs to be added to
  # the flags for gtk+ explicitly.
  depends_on 'cairo' if MACOS_VERSION < 10.6

  depends_on 'pango'
  depends_on 'gdk-pixbuf2'
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
