require 'formula'

class Mecab < Formula
  url 'http://downloads.sourceforge.net/project/mecab/mecab/0.98/mecab-0.98.tar.gz'
  homepage 'http://mecab.sourceforge.net/'
  md5 'b3d8d79e35acf0ca178e8d885309f5fd'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
