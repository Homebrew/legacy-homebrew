require 'formula'

class Ncdu < Formula
  url 'http://dev.yorhel.nl/download/ncdu-1.8.tar.gz'
  homepage 'http://dev.yorhel.nl/ncdu'
  md5 '94d7a821f8a0d7ba8ef3dd926226f7d5'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
