require 'formula'

class Mawk < Formula
  homepage 'http://invisible-island.net/mawk/mawk.html'
  url 'ftp://invisible-island.net/mawk/mawk-1.3.4-20131226.tgz'
  sha1 '5f7eb0d86e8984512facdec7c571110a6a1467b9'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline=/usr/lib",
                          "--mandir=#{man}"
    system "make install"
  end
end
