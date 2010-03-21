require 'formula'

class LibgpgError <Formula
  url 'ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.7.tar.bz2'
  homepage 'http://www.gnupg.org/'
  sha1 'bf8c6babe1e28cae7dd6374ca24ddcc42d57e902'

  def install
    ENV.j1
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-asm"
    system "make install"
  end
end
