require 'formula'

class Lzip < Formula
  url 'http://download.savannah.gnu.org/releases/lzip/lzip-1.12.tar.gz'
  md5 '69a40172db5ce896b58d862c50fcd517'
  homepage 'http://www.nongnu.org/lzip/lzip.html'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}",
                          "CXX=#{ENV.cxx}", "CXXFLAGS=#{ENV.cflags}"
    system "make install"
  end
end
