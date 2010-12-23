require 'formula'

class Lzlib <Formula
  url 'http://download.savannah.gnu.org/releases/lzip/lzlib-1.0.tar.gz'
  homepage 'http://www.nongnu.org/lzip/lzlib.html'
  md5 '39bfe00964a03be95d51ebbe9104b337'


  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
