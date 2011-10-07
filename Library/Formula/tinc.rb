require 'formula'

class Tinc < Formula
  url 'http://www.tinc-vpn.org/packages/tinc-1.0.16.tar.gz'
  homepage 'http://www.tinc-vpn.org'
  sha1 '6700e63c548228b1675f243f0075f98511f1e3a8'

  depends_on 'lzo'

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make"
    system "make install"
  end
end
