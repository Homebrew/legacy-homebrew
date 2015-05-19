require 'formula'

class Ipv6calc < Formula
  desc "Small utility for manipulating IPv6 addresses"
  homepage 'http://www.deepspace6.net/projects/ipv6calc.html'
  url 'ftp://ftp.deepspace6.net/pub/ds6/sources/ipv6calc/ipv6calc-0.94.1.tar.gz'
  sha1 'c36689ed84472bb39897167fea14529b06da4647'

  def install
    # This needs --mandir, otherwise it tries to install to /share/man/man8.
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
