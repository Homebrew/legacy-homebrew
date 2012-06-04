require 'formula'

class Mecab < Formula
  homepage 'http://mecab.sourceforge.net/'
  url 'http://mecab.googlecode.com/files/mecab-0.994.tar.gz'
  sha1 '5fcad4b7ccc2b5f6f37dea9ef6f2ef602bb92d54'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
