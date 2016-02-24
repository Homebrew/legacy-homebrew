class Flowgrind < Formula
  desc "TCP measurement tool, similar to iperf or netperf"
  homepage "https://launchpad.net/flowgrind"
  url "https://launchpad.net/flowgrind/trunk/flowgrind-0.7.5/+download/flowgrind-0.7.5.tar.bz2"
  sha256 "7d7fec5e62d34422a7cadeab4a5d65eb3ffb600e8e6861fd3cbf16c29b550ae4"
  revision 1

  bottle do
    cellar :any
    sha256 "8c0bb19bd06f461cf1b503d986d27cc9d53ff77f0951724d3ec2e034a49544ff" => :el_capitan
    sha256 "8f24b66fcaf038330243e0a599d66a8ff243376d482ff351e0f818604ea9c7a0" => :yosemite
    sha256 "58419e4ae25be3b854b2960ae3dc70bbb61c4a83fd528d9f3673c57ebf9f3e96" => :mavericks
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
