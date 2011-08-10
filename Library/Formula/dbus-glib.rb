require 'formula'

class DbusGlib < Formula
  homepage 'http://library.gnome.org/devel/dbus-glib/'
  url 'http://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.92.tar.gz'
  sha1 '69aa860251a2c916907ac7b34d5a40196cf073ff'

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
