require 'formula'

class Libassuan < Formula
  homepage 'http://www.gnupg.org/related_software/libassuan/index.en.html'
  url 'ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-2.1.1.tar.bz2'
  sha1 '8bd3826de30651eb8f9b8673e2edff77cd70aca1'

  depends_on 'libgpg-error'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
