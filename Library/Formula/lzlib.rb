require 'formula'

class Lzlib < Formula
  url 'http://download.savannah.gnu.org/releases/lzip/lzlib-1.2.tar.gz'
  homepage 'http://www.nongnu.org/lzip/lzlib.html'
  md5 '7a77358000929bb0a31ad6b68a139b9d'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}",
                          "CPPFLAGS=#{ENV.cppflags}",
                          "CXXFLAGS=#{ENV.cflags}",
                          "LDFLAGS=#{ENV.ldflags}"
    system "make install"
  end
end
