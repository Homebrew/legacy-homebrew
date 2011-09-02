require 'formula'

class Ipv6calc < Formula
  url 'ftp://ftp.bieringer.de/pub/linux/IPv6/ipv6calc/ipv6calc-0.90.0.tar.gz'
  homepage 'http://www.deepspace6.net/projects/ipv6calc.html'
  md5 'c1a654214058fdac5f8c2ba6a196e2b8'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
