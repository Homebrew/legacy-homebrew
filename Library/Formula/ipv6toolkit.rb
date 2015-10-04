class Ipv6toolkit < Formula
  desc "Security assessment and troubleshooting tool for IPv6"
  homepage "http://www.si6networks.com/tools/ipv6toolkit/"
  url "http://www.si6networks.com/tools/ipv6toolkit/ipv6toolkit-v2.0.tar.gz"
  sha256 "16f13d3e7d17940ff53f028ef0090e4aa3a193a224c97728b07ea6e26a19e987"

  bottle do
    cellar :any
    sha256 "405c13a00007d35252de0999782ee56ae57cc32f0bcb955c44857c3f72ef1d5d" => :yosemite
    sha256 "11a2ac433ca270b0daa2bf446d519cff84b99b3613b90729b2111412e2f4ec77" => :mavericks
    sha256 "db171dc5d8df41460364822cbd96a2c0cead032471ea639118a5f38654e53556" => :mountain_lion
  end

  def install
    system "make"
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX=", "MANPREFIX=/share"
  end

  test do
    system "#{bin}/addr6", "-a", "fc00::1"
  end
end
