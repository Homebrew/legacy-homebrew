require 'formula'

class LibgpgError <Formula
  url 'ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.9.tar.bz2'
  homepage 'http://www.gnupg.org/'
  sha1 '6836579e42320b057a2372bbcd0325130fe2561e'

  def install
    ENV.j1
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
