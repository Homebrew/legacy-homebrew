require 'formula'

class Ncdu < Formula
  url 'http://dev.yorhel.nl/download/ncdu-1.7.tar.gz'
  homepage 'http://dev.yorhel.nl/ncdu'
  md5 '172047c29d232724cc62e773e82e592a'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
