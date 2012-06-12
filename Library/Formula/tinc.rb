require 'formula'

class Tinc < Formula
  homepage 'http://www.tinc-vpn.org'
  url 'http://www.tinc-vpn.org/packages/tinc-1.0.18.tar.gz'
  sha1 'e5ab3e880ced785b6774b9851b48e73604cf3627'

  depends_on 'lzo'

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make"
    system "make install"
  end
end
