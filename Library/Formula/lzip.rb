require 'formula'

class Lzip < Formula
  homepage 'http://www.nongnu.org/lzip/lzip.html'
  url 'http://download.savannah.gnu.org/releases/lzip/lzip-1.14.tar.gz'
  sha1 'ee54a3f39f7bf96ec677765f88b8458d0988bf10'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}",
                          "CXXFLAGS=#{ENV.cflags}"
    system "make check"
    ENV.j1
    system "make install"
  end
end
