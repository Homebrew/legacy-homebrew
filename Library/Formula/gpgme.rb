require 'formula'

class Gpgme < Formula
  homepage 'http://www.gnupg.org/related_software/gpgme/'
  url 'ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-1.4.0.tar.bz2'
  sha1 '897e36c1d3f6595d69fb37c820aaa162daa0e369'

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
