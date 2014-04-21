require 'formula'

class Libxslt < Formula
  homepage 'http://xmlsoft.org/XSLT/'
  url 'ftp://xmlsoft.org/libxml2/libxslt-1.1.28.tar.gz'
  mirror 'http://xmlsoft.org/sources/libxslt-1.1.28.tar.gz'
  sha1 '4df177de629b2653db322bfb891afa3c0d1fa221'

  keg_only :provided_by_osx

  depends_on 'libxml2'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libxml-prefix=#{Formula["libxml2"].prefix}"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    To allow the nokogiri gem to link against this libxslt run:
      gem install nokogiri -- --with-xslt-dir=#{opt_prefix}
    EOS
  end
end
