require 'formula'

class Libxslt < Formula
  homepage 'http://xmlsoft.org/XSLT/'
  url 'ftp://xmlsoft.org/libxml2/libxslt-1.1.26.tar.gz'
  sha1 '69f74df8228b504a87e2b257c2d5238281c65154'

  keg_only :provided_by_osx

  depends_on 'libxml2'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libxml-prefix=#{Formula.factory('libxml2').prefix}"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    To allow the nokogiri gem to link against this libxslt run:
      gem install nokogiri -- --with-xslt-dir=#{prefix}
    EOS
  end
end
