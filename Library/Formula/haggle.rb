require 'formula'

class Haggle < Formula
  homepage 'http://code.google.com/p/haggle/'
  url 'http://haggle.googlecode.com/files/haggle-0.4.tar.gz'
  md5 '36360862dcd88d5f533fea90544d55c7'

  depends_on 'sqlite'

  fails_with :clang do
    build 318
    cause "no class named 'const_iterator' in 'List<T>'"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
