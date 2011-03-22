require 'formula'

class Gifsicle < Formula
  url 'http://www.lcdf.org/gifsicle/gifsicle-1.61.tar.gz'
  homepage 'http://www.lcdf.org/gifsicle/'
  md5 '3d9e45873daaf960a35d1b89505f1101'

  def install
    system "./configure", "--enable-all", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
