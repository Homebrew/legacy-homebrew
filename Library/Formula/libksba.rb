require 'formula'

class Libksba < Formula
  url 'ftp://ftp.gnupg.org/gcrypt/libksba/libksba-1.2.0.tar.bz2'
  homepage 'http://www.gnupg.org/related_software/libksba/index.en.html'
  sha1 '0c4e593464b9dec6f53c728c375d54a095658230'

  depends_on 'libgpg-error'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
