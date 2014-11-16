require 'formula'

class FetchCrl < Formula
  homepage 'http://wiki.nikhef.nl/grid/FetchCRL3'
  url 'https://dist.eugridpma.info/distribution/util/fetch-crl3/fetch-crl-3.0.13.tar.gz'
  sha1 'bb1de570e8c4b977a8ec623c808df80cd10a3d8f'

  def install
    system "make", "install", "PREFIX=#{prefix}", "ETC=#{etc}", "CACHE=#{var}/cache"
  end
end
