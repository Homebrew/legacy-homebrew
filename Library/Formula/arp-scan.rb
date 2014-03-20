require 'formula'

class ArpScan < Formula
  homepage 'http://www.nta-monitor.com/tools-resources/security-tools/arp-scan'
  url 'http://www.nta-monitor.com/tools/arp-scan/download/arp-scan-1.8.tar.gz'
  sha1 '26ebf18eff367aaf99307841bec9e8b9e596c3bb'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/arp-scan", "-V"
  end
end
