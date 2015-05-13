require 'formula'

class FetchCrl < Formula
  homepage 'http://wiki.nikhef.nl/grid/FetchCRL3'
  url 'https://dist.eugridpma.info/distribution/util/fetch-crl3/fetch-crl-3.0.16.tar.gz'
  sha1 '3c89e751bc055492a5975fcf11d7ce5ca3309489'

  def install
    system "make", "install", "PREFIX=#{prefix}", "ETC=#{etc}", "CACHE=#{var}/cache"
  end
end
