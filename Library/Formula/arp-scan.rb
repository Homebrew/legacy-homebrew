require 'formula'

class ArpScan < Formula
  homepage 'http://www.nta-monitor.com/tools-resources/security-tools/arp-scan'
  url 'http://www.nta-monitor.com/files/arp-scan/arp-scan-1.9.tar.gz'
  sha1 '6bf698572b21242778df9d2019fd386b2a21a135'

  bottle do
    sha1 "90cc962c894c21bddbaf2d88fe47c9fcef784c47" => :mavericks
    sha1 "25fca5b74656e3facbd40963e550042a993f4cac" => :mountain_lion
    sha1 "9b693b9695209bec034828b827f8f84574492b34" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/arp-scan", "-V"
  end
end
