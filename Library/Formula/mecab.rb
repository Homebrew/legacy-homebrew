require 'formula'

class Mecab < Formula
  homepage 'http://mecab.sourceforge.net/'
  url 'http://mecab.googlecode.com/files/mecab-0.996.tar.gz'
  sha1 '15baca0983a61c1a49cffd4a919463a0a39ef127'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
