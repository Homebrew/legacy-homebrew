class IpRelay < Formula
  desc "TCP traffic shaping relay application"
  homepage "http://www.stewart.com.au/ip_relay/"
  url "http://www.stewart.com.au/ip_relay/ip_relay-0.71.tgz"
  sha256 "0cf6c7db64344b84061c64e848e8b4f547b5576ad28f8f5e67163fc0382d9ed3"

  bottle :unneeded

  def install
    bin.install "ip_relay.pl" => "ip_relay"
  end

  test do
    shell_output("#{bin}/ip_relay -b", 1)
  end
end
