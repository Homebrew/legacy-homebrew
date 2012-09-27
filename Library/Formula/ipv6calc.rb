require 'formula'

class Ipv6calc < Formula
  homepage 'http://www.deepspace6.net/projects/ipv6calc.html'
  url 'ftp://ftp.deepspace6.net/pub/ds6/sources/ipv6calc/ipv6calc-0.93.1.tar.gz'
  sha1 '8cd23ed0bee03d79c70662e64ab4c7aae1219439'

  def install
    # This needs --mandir, otherwise it tries to install to /share/man/man8.
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
