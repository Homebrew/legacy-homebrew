require 'formula'

class Plzip < Formula
  url 'http://download.savannah.gnu.org/releases/lzip/plzip-0.8.tar.gz'
  homepage 'http://www.nongnu.org/lzip/plzip.html'
  md5 '4e43d32bc69c247235b0195feb25aab4'

  depends_on 'lzlib'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
