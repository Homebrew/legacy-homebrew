require 'formula'

class Tinc < Formula
  homepage 'http://www.tinc-vpn.org'
  url 'http://www.tinc-vpn.org/packages/tinc-1.0.20.tar.gz'
  sha1 '3120b19d78e1981c0aaeae7519d81bdb657cb926'

  depends_on 'lzo'

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make"
    system "make install"
  end
end
