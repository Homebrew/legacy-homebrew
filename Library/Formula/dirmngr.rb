require 'formula'

class Dirmngr < Formula
  homepage 'http://www.gnupg.org'
  url 'ftp://ftp.gnupg.org/gcrypt/dirmngr/dirmngr-1.1.0.tar.bz2'
  sha1 'a7a7d1432db9edad2783ea1bce761a8106464165'

  depends_on 'libassuan'
  depends_on 'libgpg-error'
  depends_on 'libgcrypt'
  depends_on 'libksba'
  depends_on 'pth'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make"
    system "make install"
  end
end
