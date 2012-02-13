require 'formula'

class Mecab < Formula
  url 'http://mecab.googlecode.com/files/mecab-0.993.tar.gz'
  homepage 'http://mecab.sourceforge.net/'
  sha1 '7e5daa765e83fe0f5d46f33a3b96dfab49299946'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
