require 'formula'

class ArpScan < Formula
  url 'http://www.nta-monitor.com/tools/arp-scan/download/arp-scan-1.8.tar.gz'
  homepage 'http://www.nta-monitor.com/tools/arp-scan/'
  md5 'be8826574ec566217eb7ca040fe472f9'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "arp-scan -V"
  end
end
