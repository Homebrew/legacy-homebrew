require 'formula'

class Dbus <Formula
  url 'http://dbus.freedesktop.org/releases/dbus/dbus-1.2.16.tar.gz'
  homepage 'http://www.freedesktop.org/wiki/Software/dbus'
  md5 'c7a47b851ebe02f6726b65b78d1b730b'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
