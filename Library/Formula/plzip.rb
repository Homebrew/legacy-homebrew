require 'formula'

class Plzip < Formula
  homepage 'http://www.nongnu.org/lzip/plzip.html'
  url 'http://download.savannah.gnu.org/releases/lzip/plzip-1.1.tar.gz'
  sha1 '22d3bba78b9219e7976372e24773d3abc0ff4563'

  depends_on 'lzlib'

  def install
    system "./configure", "--prefix=#{prefix}", "CXX=#{ENV.cxx}",
                          "CXXFLAGS=#{ENV.cflags}"
    system "make"
    system "make check"
    system "make install"
  end
end
