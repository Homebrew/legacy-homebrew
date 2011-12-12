require 'formula'

class Gpgme < Formula
  url 'ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-1.3.1.tar.bz2'
  homepage 'http://www.gnupg.org/gpgme.html'
  sha1 '7d19a95a2239da13764dad7f97541be884ec5a37'

  depends_on 'gnupg'
  depends_on 'libgpg-error'
  depends_on 'libassuan'
  depends_on 'pth'

  fails_with_llvm :build => 2334

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
