require 'formula'

class Atf <Formula
  url 'ftp://ftp.NetBSD.org/pub/NetBSD/misc/jmmv/atf/0.12/atf-0.12.tar.gz'
  homepage 'http://www.netbsd.org/~jmmv/atf/index.html'
  md5 'e3681dcf39f514bcddf057cabecf4944'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}"
    system "make install"
  end
end
