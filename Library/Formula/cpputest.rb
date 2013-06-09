require 'formula'

class Cpputest < Formula
  homepage 'http://www.cpputest.org/'
  url 'https://github.com/cpputest/cpputest.github.io/blob/master/releases/cpputest-3.4.zip?raw=true'
  sha1 'c3ff5fd822d59701ff55d0264b295e665ca35ce8'

  fails_with :clang do
    build 425
    cause 'Uses -lgcov which only comes with llvm or gcc'
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
