require 'formula'

class Ircii < Formula
  url 'http://ftp.netbsd.org/pub/pkgsrc/distfiles/ircii-20111115.tar.bz2'
  homepage 'http://www.eterna.com.au/ircii/'
  sha1 '723f89ca6c0ef0085da858076865e6493fbe9788'

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
