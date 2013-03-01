require 'formula'

class Libksba < Formula
  homepage 'http://www.gnupg.org/related_software/libksba/index.en.html'
  url 'ftp://ftp.gnupg.org/gcrypt/libksba/libksba-1.3.0.tar.bz2'
  sha1 '241afcb2dfbf3f3fc27891a53a33f12d9084d772'

  depends_on 'libgpg-error'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
