require 'formula'

class Smake < Formula
  url 'ftp://ftp.berlios.de/pub/smake/alpha/smake-1.2a49.tar.bz2'
  homepage 'http://cdrecord.berlios.de/private/smake.html'
  sha1 '7b50e1f81758fd6a732ddc7a78838bd2c96d1090'

  def install
    system "make", "GMAKE_NOWARN=true", "INS_BASE=#{prefix}", "INS_RBASE=#{prefix}", "MANDIR=share/man", "install"
  end
end
