require 'formula'

class Ircii <Formula
  url 'http://ftp.netbsd.org/pub/pkgsrc/distfiles/ircii-20081115.tar.bz2'
  homepage 'http://www.eterna.com.au/ircii/'
  md5 '128c435fcc0d6ad55d7319058ee578a0'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-default-server=irc.freenode.net",
                          "--mandir=#{prefix}/share/man",
                          "--enable-ipv6"
    system "make install -j1" # makefile is not multi-job safe
  end
end
