require 'formula'

class Lzip <Formula
  url 'http://mirrors.igsobe.com/nongnu/lzip/lzip-1.9.tar.gz'
  homepage 'http://www.nongnu.org/lzip/lzip.html'
  md5 '9e1d7f4db5b953e9f75b8500ebe0d4c0'

  def install
    system "./configure", "--prefix=#{prefix}", "CXX=#{ENV.cxx}"
    system "make check"
    system "make install"
  end
end
