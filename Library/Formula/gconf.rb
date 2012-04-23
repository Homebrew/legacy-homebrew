require 'formula'

class Gconf < Formula
  homepage 'http://projects.gnome.org/gconf/'
  url 'ftp://ftp.gnome.org/pub/GNOME/sources/GConf/3.2/GConf-3.2.3.tar.bz2'
  sha256 '52008a82a847527877d9e1e549a351c86cc53cada4733b8a70a1123925d6aff4'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'd-bus'
  depends_on 'glib'
  depends_on 'intltool'
  depends_on 'dbus-glib'
  depends_on 'orbit'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
