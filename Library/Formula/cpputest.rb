require 'formula'

class Cpputest < Formula
  homepage 'http://www.cpputest.org/'
  url 'https://github.com/cpputest/cpputest.git', :tag => 'v3.4'
  version '3.4'

  fails_with :clang do
    build 425
    cause 'Uses -lgcov which only comes with llvm or gcc'
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
