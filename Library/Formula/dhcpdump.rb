require 'formula'

class Dhcpdump < Formula
  homepage 'http://www.mavetju.org'
  url 'http://www.mavetju.org/download/dhcpdump-1.8.tar.gz'
  sha1 '96fae94d9bac4cf3b5a4c62be2b06a2d72a9fa48'

  def install
    system "make"
    bin.install "dhcpdump"
    man8.install "dhcpdump.8"
  end
end
