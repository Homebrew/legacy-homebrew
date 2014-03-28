require 'formula'

class DbusGlib < Formula
  homepage 'http://www.freedesktop.org/Software/dbus'
  url 'http://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.102.tar.gz'
  sha1 '58a8955972f6c221461a49f9c541c22e838a5776'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'd-bus'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
