class ArpScan < Formula
  desc "ARP scanning and fingerprinting tool"
  homepage "http://www.nta-monitor.com/tools-resources/security-tools/arp-scan"
  url "http://www.nta-monitor.com/files/arp-scan/arp-scan-1.9.tar.gz"
  mirror "https://github.com/royhills/arp-scan/releases/download/1.9/arp-scan-1.9.tar.gz"
  sha256 "ce908ac71c48e85dddf6dd4fe5151d13c7528b1f49717a98b2a2535bd797d892"

  bottle do
    sha1 "90cc962c894c21bddbaf2d88fe47c9fcef784c47" => :mavericks
    sha1 "25fca5b74656e3facbd40963e550042a993f4cac" => :mountain_lion
    sha1 "9b693b9695209bec034828b827f8f84574492b34" => :lion
  end

  head do
    url "https://github.com/royhills/arp-scan.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "homebrew/dupes/libpcap" => :optional

  def install
    system "autoreconf", "--install" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/arp-scan", "-V"
  end
end
