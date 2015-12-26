class Flowgrind < Formula
  desc "TCP measurement tool, similar to iperf or netperf"
  homepage "https://launchpad.net/flowgrind"
  url "https://launchpad.net/flowgrind/trunk/flowgrind-0.7.5/+download/flowgrind-0.7.5.tar.bz2"
  sha256 "7d7fec5e62d34422a7cadeab4a5d65eb3ffb600e8e6861fd3cbf16c29b550ae4"

  bottle do
    cellar :any
    sha256 "b0112d964b87ecaabba6f02d3bcfbd52fb06ec233e6f23c3399442954680fd44" => :yosemite
    sha256 "7da941ae0f9e69edb1902ad8b1afa7664c06ec76dfc4146a2f4e8d46fa470d00" => :mavericks
    sha256 "39820ab6c78d0368244c6e7547e479a1e612ca2bba278792e754780899424b00" => :mountain_lion
  end

  depends_on "gsl"
  depends_on "xmlrpc-c"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/flowgrind", "--version"
  end
end
