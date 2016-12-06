require 'formula'

class Libantlr3c < Formula
  homepage 'http://www.antlr.org'
  url 'http://www.antlr.org/download/C/libantlr3c-3.4.tar.gz'
  sha1 'faa9ab43ab4d3774f015471c3f011cc247df6a18'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
