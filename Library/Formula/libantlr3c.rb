require 'formula'

class Libantlr3c < Formula
  url 'http://www.antlr.org/download/C/libantlr3c-3.4.tar.gz'
  homepage 'http://www.antlr.org/'
  md5 '08b1420129d5dccd0f4461cedf2a0d7d'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-64bit",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
