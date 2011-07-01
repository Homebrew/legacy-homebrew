require 'formula'

class Libassuan < Formula
  url 'ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-2.0.1.tar.bz2'
  homepage 'http://www.gnupg.org/related_software/libassuan/index.en.html'
  sha1 'b7e9dbd41769cc20b1fb7db9f2ecdf276ffc352c'

  depends_on 'libgpg-error'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
