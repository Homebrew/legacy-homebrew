require 'formula'

class Mecab < Formula
  homepage 'http://mecab.sourceforge.net/'
  url 'https://mecab.googlecode.com/files/mecab-0.996.tar.gz'
  sha1 '15baca0983a61c1a49cffd4a919463a0a39ef127'

  bottle do
    revision 1
    sha1 "73f5e7206a4482f7ab714b0690ad3eeac7f0c9e0" => :yosemite
    sha1 "530ee77a2f13cce3225abd0cd9401858219959d9" => :mavericks
    sha1 "9747369cd4c0aa246e6a973c4f2e5652e174bae8" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
