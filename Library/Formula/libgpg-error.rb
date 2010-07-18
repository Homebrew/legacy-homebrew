require 'formula'

class LibgpgError <Formula
  url 'ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.8.tar.bz2'
  homepage 'http://www.gnupg.org/'
  sha1 'f5cf677a7cd684645feaa9704d09eb5cd6d97e8a'

  def install
    ENV.j1
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
