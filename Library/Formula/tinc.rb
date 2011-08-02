require 'formula'

class Tinc < Formula
  url 'http://www.tinc-vpn.org/packages/tinc-1.0.13.tar.gz'
  homepage 'http://www.tinc-vpn.org'
  md5 '86263994d38c750431efd17e9a91a248'

  depends_on 'lzo'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
