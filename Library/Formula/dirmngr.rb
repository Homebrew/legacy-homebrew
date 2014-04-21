require 'formula'

class Dirmngr < Formula
  homepage 'http://www.gnupg.org'
  url 'ftp://ftp.gnupg.org/gcrypt/dirmngr/dirmngr-1.1.1.tar.bz2'
  sha1 'e708d4aa5ce852f4de3f4b58f4e4f221f5e5c690'
  revision 1

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
