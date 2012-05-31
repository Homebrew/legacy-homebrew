require 'formula'

class DbusGlib < Formula
  homepage 'http://library.gnome.org/devel/dbus-glib/'
  url 'http://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.98.tar.gz'
  sha1 '203f02e41eba1aeac8986e655d794c8833e437bf'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'd-bus'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
