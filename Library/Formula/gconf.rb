require 'formula'

class Gconf < Formula
  homepage 'http://projects.gnome.org/gconf/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/GConf/3.2/GConf-3.2.6.tar.xz'
  sha256 '1912b91803ab09a5eed34d364bf09fe3a2a9c96751fde03a4e0cfa51a04d784c'

  depends_on 'pkg-config' => :build
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
