require 'formula'

class Sgrep < Formula
  homepage 'http://www.cs.helsinki.fi/u/jjaakkol/sgrep.html'
  url 'ftp://ftp.cs.helsinki.fi/pub/Software/Local/Sgrep/sgrep-1.92a.tar.gz'
  sha1 '0a51843822e9d986f08ad9e4c5d0e7b260508956'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--datadir=#{share}/sgrep"
    system "make install"
  end
end
