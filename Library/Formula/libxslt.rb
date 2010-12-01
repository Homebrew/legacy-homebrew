require 'formula'

class Libxslt < Formula
  url 'ftp://xmlsoft.org/libxml2/libxslt-1.1.26.tar.gz'
  homepage 'http://xmlsoft.org/XSLT/'
  md5 'e61d0364a30146aaa3001296f853b2b9'
  depends_on 'libxml2'

  def install
    libxml2_path = `brew --prefix libxml2`
    puts libxml2_path
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "-with-libxml-prefix=#{libxml2_path}"
    system "/usr/bin/make"
    system "/usr/bin/make install"
  end
end