require 'formula'

class Clutter < Formula
  homepage 'http://clutter-project.org/'
  url 'http://download.gnome.org/sources/clutter/1.10/clutter-1.10.8.tar.xz'
  sha256 '7c08c2deff62c134c1a3d18e04dcb6fbae4bbc541c800638b9fc3d71fe4a64bf'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'glib'
  depends_on 'gdk-pixbuf'
  depends_on 'cogl'
  depends_on 'cairo' # for cairo-gobject
  depends_on 'atk'
  depends_on 'pango'
  depends_on 'json-glib'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-introspection",
                          "--enable-quartz-backend",
                          "--disable-x11-backend"
    system "make install"
  end
end
