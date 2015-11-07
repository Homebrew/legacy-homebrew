class Iproute2mac < Formula
  desc "CLI wrapper for basic network utilities on Mac OS X - ip command"
  homepage "https://github.com/brona/iproute2mac"
  url "http://github.com/brona/iproute2mac/archive/v1.1.0.tar.gz"
  sha256 "3149dc23d5487e837646f50572d512a31799c74cf21288609887cbf8e465d4e6"

  depends_on :python

  def install
    bin.install "src/ip.py" => "ip"
  end

  test do
    pipe_output("#{bin}/ip route")
    assert $?.success?, "Calling route failed"
    pipe_output("#{bin}/ip address")
    assert $?.success?, "Calling ifconfig failed"
    pipe_output("#{bin}/ip neigh")
    assert $?.success?, "Calling arp failed"
  end
end
