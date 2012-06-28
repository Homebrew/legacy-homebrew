require 'formula'

class GnuTypist < Formula
  homepage 'http://www.gnu.org/software/gtypist/'
  url 'http://ftpmirror.gnu.org/gtypist/gtypist-2.9.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gtypist/gtypist-2.9.1.tar.gz'
  sha256 'a5885654aab74027999a67a9bbd7c3b6823479f89a6f1439244bf9c5536fb67d'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
