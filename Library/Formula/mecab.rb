require 'formula'

class Mecab < Formula
  homepage 'http://mecab.sourceforge.net/'
  url 'http://mecab.googlecode.com/files/mecab-0.994.tar.gz'
  sha1 '9d283f9d243b1a58a2845ff60797c11a88b1f926'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
