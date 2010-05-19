require 'formula'

class Gtkx <Formula
  url 'ftp://ftp.gnome.org/pub/gnome/sources/gtk+/2.20/gtk+-2.20.1.tar.bz2'
  homepage 'http://www.gtk.org/'
  sha256 '0e081731d21e34ff45c82199490c2889504fa8b3c7e117c043e82ababaec0f65'

  aka 'gtk'

  depends_on 'pkg-config'
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'pango'
  depends_on 'jasper' => :optional
  depends_on 'atk' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-glibtest"
    system "make install"
  end
end
