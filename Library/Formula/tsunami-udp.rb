require 'formula'

class TsunamiUdp < Formula
  head 'cvs://:pserver:anonymous@tsunami-udp.cvs.sourceforge.net:/cvsroot/tsunami-udp:tsunami-udp', :using => :cvs
  homepage 'http://tsunami-udp.sourceforge.net'

  def install
    system "aclocal"
    system "automake"
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
