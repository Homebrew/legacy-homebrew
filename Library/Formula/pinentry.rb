require 'formula'

class Pinentry <Formula
  url 'ftp://ftp.gnupg.org/gcrypt/pinentry/pinentry-0.8.0.tar.gz'
  homepage 'http://www.gnupg.org/related_software/pinentry/index.en.html'
  sha1 '381f9ee47b9f198e1be5d3ec4e043067a7e97912'

  depends_on 'pkg-config'
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
