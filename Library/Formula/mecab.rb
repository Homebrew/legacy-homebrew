require 'formula'

class Mecab < Formula
  url 'http://mecab.googlecode.com/files/mecab-0.99.tar.gz'
  homepage 'http://mecab.sourceforge.net/'
  sha1 '08e55c28787c18774017bc788fdca9a16b96da97'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
