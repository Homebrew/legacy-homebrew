require 'formula'

class Ircii < Formula
  url 'http://ftp.netbsd.org/pub/pkgsrc/distfiles/ircii-20110228.tar.bz2'
  homepage 'http://www.eterna.com.au/ircii/'
  md5 '062f2d2a3453a643d4679b95917dd93d'

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
