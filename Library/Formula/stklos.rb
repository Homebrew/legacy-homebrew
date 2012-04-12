require 'formula'

class Stklos < Formula
  url 'http://www.stklos.net/download/stklos-1.01.tar.gz'
  homepage 'http://www.stklos.net/'
  md5 '2c370627c3abd07c30949b2ee7d3d987'

  depends_on 'gmp'
  depends_on 'pcre'
  depends_on 'bdw-gc'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
