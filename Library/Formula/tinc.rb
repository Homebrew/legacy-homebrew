require 'formula'

class Tinc < Formula
  url 'http://www.tinc-vpn.org/packages/tinc-1.0.17.tar.gz'
  homepage 'http://www.tinc-vpn.org'
  sha1 '3e07c53978868766bf805397efe5842e686464d8'

  depends_on 'lzo'

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make"
    system "make install"
  end
end
