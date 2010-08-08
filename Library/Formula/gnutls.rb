require 'formula'

class Gnutls <Formula
  url 'http://ftp.gnu.org/pub/gnu/gnutls/gnutls-2.8.5.tar.bz2'
  homepage 'http://www.gnu.org/software/gnutls/gnutls.html'
  sha1 '5121c52efd4718ad3d8b641d28343b0c6abaa571'

  depends_on 'libgcrypt'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-guile"
    system "make install"
  end
end
