require 'formula'

class Gecode < Formula
  url 'http://www.gecode.org/download/gecode-3.7.1.tar.gz'
  homepage 'http://www.gecode.org/'
  md5 'b4191d8cfafa18bd9b78594544be2a04'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
