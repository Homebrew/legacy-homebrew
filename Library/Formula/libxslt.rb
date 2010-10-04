require 'formula'

class Libxslt <Formula
  url 'ftp://xmlsoft.org/libxslt/libxslt-1.1.26.tar.gz'
  homepage 'http://xmlsoft.org/XSLT/'
  md5 'e61d0364a30146aaa3001296f853b2b9'

  depends_on 'libxml2'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
