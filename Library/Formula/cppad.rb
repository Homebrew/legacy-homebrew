require 'formula'

class Cppad < Formula
  version "20120316"
  url 'http://www.coin-or.org/download/source/CppAD/cppad-20120316.gpl.tgz'
  homepage 'http://www.coin-or.org/CppAD'
  md5 'a13c7859c909714b8607a79cf2d99ddd'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

end
