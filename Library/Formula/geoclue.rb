require 'formula'

class Geoclue < Formula
  url "http://folks.o-hand.com/jku/geoclue-releases/geoclue-0.12.0.tar.gz"
  homepage "http://freedesktop.org/wiki/Software/GeoClue"
  md5 "33af8307f332e0065af056ecba65fec2"

  depends_on "dbus-glib"
  depends_on "gconf"
  depends_on "orbit2"

  def install
    system "./configure --prefix=#{prefix}"
    system "make install"
  end
end
