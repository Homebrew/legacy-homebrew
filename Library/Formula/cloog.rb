require 'formula'

class Cloog < Formula
  url 'http://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-0.17.0.tar.gz'
  homepage 'http://www.cloog.org/'
  md5 '0aa3302c81f65ca62c114e5264f8a802'

  depends_on 'gmp'

  def install
    gmp = Formula.factory 'gmp'

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-gmp=system",
                          "--with-gmp-prefix=#{gmp.prefix}"
    system "make install"
  end
end
