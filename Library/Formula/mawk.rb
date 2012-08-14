require 'formula'

class Mawk < Formula
  homepage 'http://invisible-island.net/mawk/mawk.html'
  url 'ftp://invisible-island.net/mawk/mawk-1.3.4-20120627.tgz'
  sha1 'bf920a9f74830a0cebbb6573c0cf3c9b5e920946'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline=/usr/lib",
                          "--mandir=#{man}"
    system "make install"
  end
end
