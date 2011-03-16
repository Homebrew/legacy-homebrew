require 'formula'

class Stklos < Formula
  url 'http://www.stklos.net/download/stklos-1.00.tar.gz'
  homepage 'http://www.stklos.net/'
  md5 '3fd4809205871b65882be9b9f7e17090'

  depends_on 'gmp'
  depends_on 'pcre'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
