require 'formula'

class Sgrep < Formula
  url 'ftp://ftp.cs.helsinki.fi/pub/Software/Local/Sgrep/sgrep-1.92a.tar.gz'
  homepage 'http://www.cs.helsinki.fi/u/jjaakkol/sgrep.html'
  md5 '99eb1ed515648f653fc7be45e0896378'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--datadir=#{share}/sgrep"
    system "make install"
  end
end
