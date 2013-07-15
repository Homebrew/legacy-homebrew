require 'formula'

class Ircii < Formula
  homepage 'http://www.eterna.com.au/ircii/'
  url 'http://ftp.netbsd.org/pub/pkgsrc/distfiles/ircii-20111115.tar.bz2'
  sha1 '723f89ca6c0ef0085da858076865e6493fbe9788'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-default-server=irc.freenode.net",
                          "--enable-ipv6"
    system "make"
    ENV.deparallelize
    system "make install"
  end
end
