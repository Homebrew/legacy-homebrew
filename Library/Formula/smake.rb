require 'formula'

class Smake < Formula
  url 'ftp://ftp.berlios.de/pub/smake/alpha/smake-1.2a49.tar.bz2'
  homepage 'http://cdrecord.berlios.de/private/smake.html'
  md5 '1c1e5b7a2b718aca772305a84359ba7e'

  def patches
    "http://fink.cvs.sourceforge.net/viewvc/fink/dists/10.7/stable/main/finkinfo/devel/smake.patch?revision=1.1&content-type=text%2Fplain"
  end

  def install
    system "make", "GMAKE_NOWARN=true", "INS_BASE=#{prefix}", "INS_RBASE=#{prefix}", "MANDIR=share/man", "install"
  end
end
