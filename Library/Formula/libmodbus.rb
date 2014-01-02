require 'formula'

class Libmodbus < Formula
  homepage 'http://libmodbus.org'
  url 'http://libmodbus.org/site_media/build/libmodbus-3.1.1.tar.gz'
  sha1 '3878af4a93a01001dd3bb8db90d24d5180545b91'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
