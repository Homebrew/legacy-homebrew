require 'formula'

class DbusGlib < Formula
  homepage 'http://www.freedesktop.org/Software/dbus'
  url 'http://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.100.tar.gz'
  sha1 'dc58ec3466fc08cd1ec7c5ccc0d45c7881fb0610'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'd-bus'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
