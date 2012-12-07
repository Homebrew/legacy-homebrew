require 'formula'

class Libtasn1 < Formula
  homepage 'http://www.gnu.org/software/libtasn1/'
  url 'http://ftpmirror.gnu.org/libtasn1/libtasn1-3.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libtasn1/libtasn1-3.1.tar.gz'
  sha1 '40a651c82e8e842e0550b85502bd550c16ec626b'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
