require 'formula'

class Doublecpp < Formula
  url 'http://downloads.sourceforge.net/doublecpp/doublecpp-0.6.3.tar.gz'
  homepage 'http://doublecpp.sourceforge.net/'
  md5 '0537ff74de82901f2e3bd92aaa677b3d'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
