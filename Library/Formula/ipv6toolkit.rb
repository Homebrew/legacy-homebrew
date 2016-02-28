class Ipv6toolkit < Formula
  desc "Security assessment and troubleshooting tool for IPv6"
  homepage "https://www.si6networks.com/tools/ipv6toolkit/"
  url "https://www.si6networks.com/tools/ipv6toolkit/ipv6toolkit-v2.0.tar.gz"
  sha256 "16f13d3e7d17940ff53f028ef0090e4aa3a193a224c97728b07ea6e26a19e987"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "1d7d0b6b4d248ccff98362f4d7707821ae2109591717d56d3b49f0c1d6b83b16" => :el_capitan
    sha256 "d337148bcff3080cd4e94fee0adb1b5226421020bcc6296f97bcf1986dcbea6a" => :yosemite
    sha256 "cd4b85ebae536aea022ab34174c36d360b2db31a9f5c11ad58ae6aa4644ff2b0" => :mavericks
  end

  def install
    system "make"
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX=", "MANPREFIX=/share"
  end

  test do
    system "#{bin}/addr6", "-a", "fc00::1"
  end
end
