require 'formula'

class ArpScan < Formula
  homepage 'http://www.nta-monitor.com/tools-resources/security-tools/arp-scan'
  url 'http://www.nta-monitor.com/files/arp-scan/arp-scan-1.9.tar.gz'
  sha1 '6bf698572b21242778df9d2019fd386b2a21a135'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/arp-scan", "-V"
  end
end
