require 'formula'

class Libassuan < Formula
  url 'ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-2.0.2.tar.bz2'
  homepage 'http://www.gnupg.org/related_software/libassuan/index.en.html'
  sha1 'dbcd96e2525d4c3a2da9e8054a06fa517f20a185'

  depends_on 'libgpg-error'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
