require 'formula'

class Lzip <Formula
  url 'http://download.savannah.gnu.org/releases-noredirect/lzip/lzip-1.10.tar.gz'
  homepage 'http://www.nongnu.org/lzip/lzip.html'
  md5 '84879f20450a69a94e125a67f4724d12'

  def install
    system "./configure", "--prefix=#{prefix}", "CXX=#{ENV.cxx}"
    system "make check"
    system "make install"
  end
end
