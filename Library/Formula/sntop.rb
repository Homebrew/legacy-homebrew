require 'formula'

class Sntop < Formula
  homepage 'http://sntop.sourceforge.net/'
  url 'http://distcache.freebsd.org/ports-distfiles/sntop-1.4.3.tar.gz'
  sha1 '8a96bb453a83262e30215a31be508c16dbd71e27'

  depends_on 'fping'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--sysconfdir=#{etc}"
    etc.mkpath
    bin.mkpath
    man1.mkpath
    system "make install"
  end

  def caveats; <<-EOS.undent
    sntop uses fping by default. fping can only be run by root by default so
    either use sudo to run sntop or setuid root fping.

    Alternatively, run sntop using standard ping (sntop -p).
    EOS
  end
end
