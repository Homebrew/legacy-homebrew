require 'formula'

class GpgAgent < Formula
  url 'ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.17.tar.bz2'
  homepage 'http://www.gnupg.org/'
  sha1 '41ef5460417ca0a1131fc730849fe3afd49ad2de'

  depends_on 'libgpg-error'
  depends_on 'libgcrypt'
  depends_on 'libksba'
  depends_on 'libassuan'
  depends_on 'pth'
  depends_on 'pinentry'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--enable-agent-only"
    system "make install"
  end
end
