class FetchCrl < Formula
  desc "Retrieve certificate revocation lists (CRLs)"
  homepage "https://wiki.nikhef.nl/grid/FetchCRL3"
  url "https://dist.eugridpma.info/distribution/util/fetch-crl3/fetch-crl-3.0.16.tar.gz"
  sha256 "3e7c3364db3bd7403f54dfb6b970327e75fde8e5a6f722dcb24b4dcfe5a0b641"

  bottle do
    cellar :any
    sha256 "1d2f55417dea34e899a6e593bd3b331166ac9937aa8a334dfdf07b3fece96f69" => :yosemite
    sha256 "514023abc5298790e9436a54424da58bfcca3454875f56a7abd33877dc253123" => :mavericks
    sha256 "8e5bc30aea5fcc6e976b525b41a664e25990b074f90d1ff9eaa2437a97b29c13" => :mountain_lion
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "ETC=#{etc}", "CACHE=#{var}/cache"
  end
end
