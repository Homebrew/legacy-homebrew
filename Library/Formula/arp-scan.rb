require 'formula'

class ArpScan < Formula
  homepage 'http://www.nta-monitor.com/tools/arp-scan/'
  url 'http://www.nta-monitor.com/tools/arp-scan/download/arp-scan-1.8.tar.gz'
  md5 'be8826574ec566217eb7ca040fe472f9'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/arp-scan", "-V"
  end
end
