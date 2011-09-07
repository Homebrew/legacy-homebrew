require 'formula'

class Lzip < Formula
  url 'http://download.savannah.gnu.org/releases/lzip/lzip-1.11.tar.gz'
  homepage 'http://www.nongnu.org/lzip/lzip.html'
  md5 'ba9d0a705e47bcd2b73145d238aa7b58'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}",
                          "CXX=#{ENV.cxx}", "CXXFLAGS=#{ENV.cflags}"
    system "make install"
  end
end
