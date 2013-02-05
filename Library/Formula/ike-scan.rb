require 'formula'

class IkeScan < Formula
  homepage 'http://www.nta-monitor.com/tools/ike-scan/'
  url 'http://www.nta-monitor.com/tools/ike-scan/download/ike-scan-1.9.tar.gz'
  sha1 'e973742c32c7b65fe134233482c94e3e94db3b32'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-openssl"
    system "make install"
  end
end
