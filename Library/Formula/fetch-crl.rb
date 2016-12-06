require 'formula'

class FetchCrl < Formula
  homepage 'http://wiki.nikhef.nl/grid/FetchCRL3'
  url 'https://dist.eugridpma.info/distribution/util/fetch-crl3/fetch-crl-3.0.8.tar.gz'
  sha1 '5e4474d70ef5a5a1a29bff1944114ad58987f731'

  def install
    system "make", "install", "PREFIX=#{prefix}", "ETC=#{etc}", "CACHE=#{var}/cache"
  end
end
