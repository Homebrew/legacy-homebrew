require "formula"

class Ipv6toolkit < Formula
  homepage "http://www.si6networks.com/tools/ipv6toolkit/"
  url "http://www.si6networks.com/tools/ipv6toolkit/ipv6toolkit-v1.5.3.tar.gz"
  sha1 "259449d974beeb24650eade16245659ddeaba633"

  def install
    system "make"
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX=", "MANPREFIX=share"
  end

  test do
    system "#{bin}/addr6", "-a", "fc00::1"
  end
end
