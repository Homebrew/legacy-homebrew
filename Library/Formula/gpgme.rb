require 'formula'

class Gpgme < Formula
  url 'ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-1.3.0.tar.bz2'
  homepage 'http://www.gnupg.org/gpgme.html'
  sha1 '0db69082abfbbbaf86c3ab0906f5137de900da73'

  depends_on 'gnupg'
  depends_on 'libgpg-error'
  depends_on 'libassuan'

  def install
    fails_with_llvm
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-asm"
    system "make install"
  end
end
