require 'formula'

class Quvi <Formula
  url 'http://quvi.googlecode.com/files/quvi-0.1.4.tar.bz2'
  homepage 'http://code.google.com/p/quvi/'
  md5 '976c07dcf3cab275c93f7b5bc3424b02'

  depends_on 'pkg-config'
  depends_on 'pcre'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-smut",
                          "--enable-broken"
    system "make install"
  end
end
