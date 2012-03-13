require 'formula'

class Ircii < Formula
  url 'http://ftp.netbsd.org/pub/pkgsrc/distfiles/ircii-20111115.tar.bz2'
  homepage 'http://www.eterna.com.au/ircii/'
  md5 '402b3badc21a7394d9c84d15a1ddb6c5'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-default-server=irc.freenode.net",
                          "--enable-ipv6"
    system "make"
    ENV.deparallelize
    system "make install"
  end
end
