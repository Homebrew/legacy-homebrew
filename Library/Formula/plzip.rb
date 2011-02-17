require 'formula'

class Plzip <Formula
  url 'http://download.savannah.gnu.org/releases/lzip/plzip-0.7.tar.gz'
  homepage 'http://www.nongnu.org/lzip/plzip.html'
  md5 '8c9bf624ceeb7ff26122137937737c81'

  depends_on 'lzlib'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
