require 'formula'

class Smake < Formula
  homepage 'http://cdrecord.berlios.de/private/smake.html'
  url 'ftp://ftp.berlios.de/pub/smake/smake-1.2.3.tar.bz2'
  sha1 'e5bacf4d092835feeb11eeb1c788c5fafeb22dcf'

  # A sed operation silently fails on Lion or older, due
  # to some locale settings in smake's build files. The sed
  # wrapper on 10.8+ overrides them.
  env :std if MacOS.version <= :lion

  def install
    ENV.delete 'MAKEFLAGS' # the bootstrap smake does not like -j

    system "make", "GMAKE_NOWARN=true", "INS_BASE=#{libexec}", "INS_RBASE=#{libexec}", "install"
    bin.install_symlink libexec/"bin/smake"
    man1.install_symlink Dir["#{libexec}/share/man/man1/*.1"]
    man5.install_symlink Dir["#{libexec}/share/man/man5/*.5"]
  end
end
