require 'formula'

class Tinc < Formula
  homepage 'http://www.tinc-vpn.org'
  url 'http://www.tinc-vpn.org/packages/tinc-1.0.22.tar.gz'
  sha1 '4a61b5b5f2e31bda5225b1224880d25524d093e7'

  depends_on 'lzo'

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make"
    system "make install"
  end
end
