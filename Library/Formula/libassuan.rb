require 'formula'

class Libassuan < Formula
  homepage 'http://www.gnupg.org/related_software/libassuan/index.en.html'
  url 'ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-2.1.0.tar.bz2'
  sha1 'af114073610ce0b30961986c2741d5e7230c9880'

  depends_on 'libgpg-error'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
