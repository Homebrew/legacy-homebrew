require 'formula'

class FetchCrl < Formula
  homepage 'http://wiki.nikhef.nl/grid/FetchCRL3'
  url 'https://dist.eugridpma.info/distribution/util/fetch-crl3/fetch-crl-3.0.12.tar.gz'
  sha1 '78c25808517da2846f918f60ca4e86cb432cdf73'

  def install
    system "make", "install", "PREFIX=#{prefix}", "ETC=#{etc}", "CACHE=#{var}/cache"
  end
end
