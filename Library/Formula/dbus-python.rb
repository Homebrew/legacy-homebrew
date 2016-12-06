require 'formula'

class DbusPython < Formula
  homepage 'http://dbus.freedesktop.org/doc/dbus-python/'
  url 'http://dbus.freedesktop.org/releases/dbus-python/dbus-python-1.1.1.tar.gz'
  sha1 '3c15438a7ec1f0698d50557e3421564564d0e097'

  depends_on :x11
  depends_on 'd-bus'
  depends_on 'dbus-glib'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "python -c 'import dbus'"
  end
end
