require 'formula'

class Lzlib <Formula
  url 'http://download.savannah.gnu.org/releases/lzip/lzlib-1.1.tar.gz'
  homepage 'http://www.nongnu.org/lzip/lzlib.html'
  md5 '3e57ebb510b6343e93f56724cfa16510'


  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
