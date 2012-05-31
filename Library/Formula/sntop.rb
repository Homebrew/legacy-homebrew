require 'formula'

class Sntop < Formula
  homepage 'http://sntop.sourceforge.net/'
  url 'ftp://ftp.freebsd.org/pub/FreeBSD/ports/distfiles/sntop-1.4.3.tar.gz'
  md5 '0e99c64ea5a1bad6c1a32ac0dc2e9dd9'

  depends_on 'fping'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--sysconfdir=#{etc}"
    bin.mkpath
    system "make install"
  end

  def caveats; <<-EOS.undent
    sntop uses fping by default. fping can only be run by root by default so
    either use sudo to run sntop or setuid root fping.

    Alternatively, run sntop using standard ping (sntop -p).
    EOS
  end
end
