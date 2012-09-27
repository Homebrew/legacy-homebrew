require 'formula'

class Tinc < Formula
  homepage 'http://www.tinc-vpn.org'
  url 'http://www.tinc-vpn.org/packages/tinc-1.0.19.tar.gz'
  sha1 '3ae326a060a88f5a9d2a1b8fdab26671b691f8ab'

  depends_on 'lzo'

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make"
    system "make install"
  end
end
