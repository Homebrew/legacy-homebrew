require 'formula'

class Mecab < Formula
  homepage 'http://mecab.sourceforge.net/'
  url 'https://mecab.googlecode.com/files/mecab-0.996.tar.gz'
  sha1 '15baca0983a61c1a49cffd4a919463a0a39ef127'

  bottle do
    sha1 "d6435459cc7781e7823e809066266b6886be2863" => :mavericks
    sha1 "3d97f4f6338245415a36c9209e3cab0be771dbcf" => :mountain_lion
    sha1 "195c754f42fa4c2c0253ca8856cdaaa564c5acd2" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
