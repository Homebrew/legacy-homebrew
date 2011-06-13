require 'formula'

class Libharu < Formula
  homepage 'http://www.libharu.org'
  url 'http://libharu.org/files/libharu-2.2.1.tar.bz2'
  md5 '4febd7e677b1c5d54db59a608b84e79f'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          # ENV.x11 doesn't get picked up
                          "--with-png=/usr/X11"
    system "make install"
  end
end
