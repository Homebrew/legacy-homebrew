class ArpScan < Formula
  desc "ARP scanning and fingerprinting tool"
  homepage "https://github.com/royhills/arp-scan"
  url "https://github.com/royhills/arp-scan/releases/download/1.9/arp-scan-1.9.tar.gz"
  sha256 "ce908ac71c48e85dddf6dd4fe5151d13c7528b1f49717a98b2a2535bd797d892"

  bottle do
    revision 1
    sha256 "f0fdab57a9d16dc270b9bedba6c5cca5e99e2b5319268261a320dda86fa5da54" => :el_capitan
    sha256 "4a26a7bb3c586122b4aad81c17bf8427bc820ec4a4353573ffedf79087000232" => :yosemite
    sha256 "e0570d20ec6c79c1a43c9925eb5c09d7ab9589fbe9d2ce1579927800ac6c53d5" => :mavericks
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
