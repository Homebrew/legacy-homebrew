require 'formula'

class Plzip < Formula
  homepage 'http://www.nongnu.org/lzip/plzip.html'
  url 'http://download.savannah.gnu.org/releases/lzip/plzip-1.0.tar.gz'
  sha1 'cb06d7c1f1b579f1d9f90faa7fe3a8b00c01091f'

  depends_on 'lzlib'

  def install
    system "./configure", "--prefix=#{prefix}", "CXX=#{ENV.cxx}",
                          "CXXFLAGS=#{ENV.cflags}"
    system "make"
    system "make check"
    system "make install"
  end
end
