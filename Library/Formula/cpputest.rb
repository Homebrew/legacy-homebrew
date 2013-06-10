require 'formula'

class Cpputest < Formula
  homepage 'http://www.cpputest.org/'
  url 'https://github.com/cpputest/cpputest/archive/v3.4.tar.gz'
  sha1 'ecd53f5b1a92a1f2291249ce69f544392f5a8462'

  fails_with :clang do
    build 425
    cause 'Uses -lgcov which only comes with llvm or gcc'
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
