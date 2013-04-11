require 'formula'

class Smake < Formula
  homepage 'http://cdrecord.berlios.de/private/smake.html'
  url 'ftp://ftp.berlios.de/pub/smake/smake-1.2.2.tar.bz2'
  sha1 'abd5a99a6fe588afa31246f3d686c686c75bb953'

  # smake silently fails to build its binaries in superenv
  env :std

  def install
    system "make", "GMAKE_NOWARN=true", "INS_BASE=#{prefix}", "INS_RBASE=#{prefix}", "MANDIR=share/man", "install"
  end
end
