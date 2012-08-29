require 'formula'

class Gpgme < Formula
  homepage 'http://www.gnupg.org/gpgme.html'
  url 'ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-1.3.2.tar.bz2'
  sha1 '5b5ebcc4dad46ced0e436a30f5542577536619c7'

  depends_on 'gnupg'
  depends_on 'libgpg-error'
  depends_on 'libassuan'
  depends_on 'pth'

  fails_with :llvm do
    build 2334
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-static",
                          "--without-gpgsm",
                          "--without-gpgconf"
    system "make"
    system "make check"
    system "make install"
  end
end
