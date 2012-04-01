require 'formula'

class Gecode < Formula
  url 'http://www.gecode.org/download/gecode-3.7.2.tar.gz'
  homepage 'http://www.gecode.org/'
  md5 '8d505801f5730bd1b639fb2213b24919'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-examples"
    system "make install"
  end
end
