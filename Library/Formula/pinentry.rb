require 'formula'

class Pinentry < Formula
  url 'ftp://ftp.gnupg.org/gcrypt/pinentry/pinentry-0.8.1.tar.gz'
  homepage 'http://www.gnupg.org/related_software/pinentry/index.en.html'
  sha1 '84a6940175b552a8562b4014f4661dec3ff10165'

  depends_on 'pkg-config' => :build
  depends_on 'libgpg-error'
  depends_on 'libgcrypt'
  depends_on 'libksba'
  depends_on 'libassuan'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-pinentry-qt",
                          "--disable-pinentry-qt4"
    system "make install"
  end
end
