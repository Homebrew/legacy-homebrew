require 'formula'

class Libmodbus < Formula
  homepage 'http://libmodbus.org'
  url 'https://github.com/downloads/stephane/libmodbus/libmodbus-3.0.3.tar.gz'
  sha1 '28f7dcd418181306dd9e3fc1d409b8e0e963c233'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
