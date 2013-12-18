require 'formula'

class Tinc < Formula
  homepage 'http://www.tinc-vpn.org'
  url 'http://www.tinc-vpn.org/packages/tinc-1.0.23.tar.gz'
  sha1 '840dca0cc1d28a3e408f463693ef766c72d8bc90'

  depends_on 'lzo'

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make"
    system "make install"
  end
end
