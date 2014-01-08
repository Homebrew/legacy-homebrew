require 'formula'

class Sgrep < Formula
  homepage 'http://www.cs.helsinki.fi/u/jjaakkol/sgrep.html'
  url 'ftp://ftp.cs.helsinki.fi/pub/Software/Local/Sgrep/sgrep-1.94a.tar.gz'
  sha1 '4f6815d212ac6e1ed4eb2720f9b28963d1d0e99d'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--datadir=#{share}/sgrep"
    system "make install"
  end
end
