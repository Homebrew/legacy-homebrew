class ArpScan < Formula
  desc "ARP scanning and fingerprinting tool"
  homepage "http://www.nta-monitor.com/tools-resources/security-tools/arp-scan"
  url "http://www.nta-monitor.com/files/arp-scan/arp-scan-1.9.tar.gz"
  mirror "https://github.com/royhills/arp-scan/releases/download/1.9/arp-scan-1.9.tar.gz"
  sha256 "ce908ac71c48e85dddf6dd4fe5151d13c7528b1f49717a98b2a2535bd797d892"

  bottle do
    sha256 "542d9f8244c398dfa828e673ab38a6dba15ca3bfb85222011f7a76f7171cf38e" => :mavericks
    sha256 "d734f9537f9ffbf2312dfcd12fc04192b0b361cd120179e3b1c459946c5b82a9" => :mountain_lion
    sha256 "61952c8d01c234974eb7f10ac85c0816b3f2e88e2a8c9eaf8da4a72f34ab4123" => :lion
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
