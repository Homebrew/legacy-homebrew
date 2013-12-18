require 'formula'

class Gconf < Formula
  homepage 'http://projects.gnome.org/gconf/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/GConf/3.2/GConf-3.2.5.tar.xz'
  sha256 '4ddea9503a212ee126c5b46a0a958fd5484574c3cb6ef2baf38db02e819e58c6'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'd-bus'
  depends_on 'glib'
  depends_on 'dbus-glib'
  depends_on 'orbit'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
