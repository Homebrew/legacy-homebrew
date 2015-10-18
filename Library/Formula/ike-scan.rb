class IkeScan < Formula
  desc "Discover and fingerprint IKE hosts"
  homepage "http://www.nta-monitor.com/tools-resources/security-tools/ike-scan"
  url "http://www.nta-monitor.com/tools/ike-scan/download/ike-scan-1.9.tar.gz"
  sha256 "05d15c7172034935d1e46b01dacf1101a293ae0d06c0e14025a4507656f1a7b6"
  revision 1

  bottle do
    sha1 "43ea7f5447f086855d2b536555241c72d6e55df1" => :yosemite
    sha1 "67c1151191bb54bccb2b899a4101eca4f71be022" => :mavericks
    sha1 "2ebab8a22e925846ae35980944b82b142df21326" => :mountain_lion
  end

  head do
    url "https://github.com/royhills/ike-scan.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    # We probably shouldn't probe any host for VPN servers, so let's keep this simple.
    system bin/"ike-scan", "--version"
  end
end
