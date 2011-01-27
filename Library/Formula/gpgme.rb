require 'formula'

class Gpgme < Formula
  url 'ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-1.1.8.tar.bz2'
  homepage 'http://www.gnupg.org'
  sha1 'e56da614f3e6acc1cb51af767c77f4a95b05b1e8'

  depends_on 'gnupg'
  depends_on 'libgpg-error'

  def install
    fails_with_llvm
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-asm"
    system "make install"
  end
end
