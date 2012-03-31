require 'formula'

class Frobtads < Formula
  url 'http://www.tads.org/frobtads/frobtads-1.1.tar.gz'
  homepage 'http://www.tads.org/frobtads.htm'
  md5 '2d29d1449bac6f23b6c5f522209069a1'
  head 'git://git.assembla.com/frobtads.git'
  
  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
