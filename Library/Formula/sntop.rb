require 'formula'

class Sntop <Formula
  url 'ftp://ftp.freebsd.org/pub/FreeBSD/ports/distfiles/sntop-1.4.3.tar.gz'
  homepage 'http://sntop.sourceforge.net/'
  md5 '0e99c64ea5a1bad6c1a32ac0dc2e9dd9'
  version 'v1.4.3'
  depends_on 'fping'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--sysconfdir=#{etc}"
    bin.mkpath
    system "make install"
  end
end
