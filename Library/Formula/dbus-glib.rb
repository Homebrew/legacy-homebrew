require 'formula'

class DbusGlib < Formula
  homepage 'http://www.freedesktop.org/Software/dbus'
  url 'http://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.100.2.tar.gz'
  sha1 '506c3ee32b45b565c3e81685af2510a50bf60b33'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'd-bus'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
