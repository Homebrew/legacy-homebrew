class Iproute2mac < Formula
  desc "CLI wrapper for basic network utilities on Mac OS X - ip command"
  homepage "https://github.com/brona/iproute2mac"
  url "https://github.com/brona/iproute2mac/archive/v1.1.0.tar.gz"
  sha256 "3149dc23d5487e837646f50572d512a31799c74cf21288609887cbf8e465d4e6"

  bottle :unneeded

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    bin.install "src/ip.py" => "ip"
  end

  test do
    system "#{bin}/ip", "route"
    system "#{bin}/ip", "address"
    system "#{bin}/ip", "neigh"
  end
end
