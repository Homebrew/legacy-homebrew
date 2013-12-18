require 'formula'

class Mawk < Formula
  homepage 'http://invisible-island.net/mawk/mawk.html'
  url 'ftp://invisible-island.net/mawk/mawk-1.3.4-20130219.tgz'
  sha1 '8d972199614a1bbe42c5508fdaa9ff764130d8b1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline=/usr/lib",
                          "--mandir=#{man}"
    system "make install"
  end
end
