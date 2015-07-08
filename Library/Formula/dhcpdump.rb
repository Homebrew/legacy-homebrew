class Dhcpdump < Formula
  desc "Monitor DHCP traffic for debugging purposes"
  homepage "http://www.mavetju.org"
  url "http://www.mavetju.org/download/dhcpdump-1.8.tar.gz"
  sha256 "6d5eb9418162fb738bc56e4c1682ce7f7392dd96e568cc996e44c28de7f77190"

  def install
    system "make"
    bin.install "dhcpdump"
    man8.install "dhcpdump.8"
  end

  test do
    system "#{bin}/dhcpdump", "-h"
  end
end
