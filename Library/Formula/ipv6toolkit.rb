class Ipv6toolkit < Formula
  homepage "http://www.si6networks.com/tools/ipv6toolkit/"
  url "http://www.si6networks.com/tools/ipv6toolkit/ipv6toolkit-v2.0.tar.gz"
  sha1 "78e2a5ed3264cd5f5cedd26595c070442fa4379a"

  def install
    system "make"
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX=", "MANPREFIX=/share"
  end

  test do
    system "#{bin}/addr6", "-a", "fc00::1"
  end
end
