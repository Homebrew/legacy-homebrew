require 'formula'

class Stklos < Formula
  homepage 'http://www.stklos.net/'
  url 'http://www.stklos.net/download/stklos-1.10.tar.gz'
  sha1 '113551b6bee26fbe5c835ef0db292b9276cccaa0'

  depends_on 'gmp'
  depends_on 'pcre'
  depends_on 'bdw-gc'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
