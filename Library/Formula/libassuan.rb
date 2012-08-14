require 'formula'

class Libassuan < Formula
  homepage 'http://www.gnupg.org/related_software/libassuan/index.en.html'
  url 'ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-2.0.3.tar.bz2'
  sha1 '2bf4eba3b588758e349976a7eb9e8a509960c3b5'

  depends_on 'libgpg-error'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
