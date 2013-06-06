require 'formula'

class Plzip < Formula
  homepage 'http://www.nongnu.org/lzip/plzip.html'
  url 'http://download.savannah.gnu.org/releases/lzip/plzip-0.9.tar.gz'
  sha1 '051d9094a4d7b98c76b92ad2e48e963ca5bf100f'

  depends_on 'lzlib'

  def install
    system "./configure", "--prefix=#{prefix}", "CXX=#{ENV.cxx}",
                          "CXXFLAGS=#{ENV.cflags}"
    system "make"
    system "make check"
    system "make install"
  end
end
