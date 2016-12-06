require 'formula'

class Rans < Formula
  head 'git://github.com/sinya8282/RANS.git'
  homepage 'http://sinya8282.github.com/RANS/'

  depends_on 'gmp'
  depends_on 'gtest'
  depends_on 'gflags'

  def install
    system "make all -j"
    system "make check"
    system "make install prefix=#{prefix}"
  end
end
