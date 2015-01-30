class IkeScan < Formula
  homepage "http://www.nta-monitor.com/tools/ike-scan/"
  url "http://www.nta-monitor.com/tools/ike-scan/download/ike-scan-1.9.tar.gz"
  sha1 "e973742c32c7b65fe134233482c94e3e94db3b32"
  revision 1

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
