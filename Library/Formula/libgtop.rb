require 'formula'

class Libgtop < Formula
  homepage 'http://library.gnome.org/devel/libgtop/stable/'
  url 'http://ftp.gnome.org/pub/gnome/sources/libgtop/2.28/libgtop-2.28.5.tar.xz'
  sha1 '7104a7546252e3fb26d162e9b34e1f7df42236d1'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'glib'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x"
    system "make install"
  end
end
