class Jerm < Formula
  desc "Communication terminal through serial and TCP/IP interfaces"
  homepage "http://www.bsddiary.net/jerm/"
  url "http://www.bsddiary.net/jerm/jerm-8096.tar.gz"
  version "0.8096"
  sha256 "8a63e34a2c6a95a67110a7a39db401f7af75c5c142d86d3ba300a7b19cbcf0e9"

  def install
    system "make", "all"
    bin.install %w[jerm tiocdtr]
    man1.install Dir["*.1"]
  end
end
