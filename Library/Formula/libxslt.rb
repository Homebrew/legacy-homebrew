require 'formula'

class Libxslt < Formula
  homepage 'http://xmlsoft.org/XSLT/'
  url 'ftp://xmlsoft.org/libxml2/libxslt-1.1.28.tar.gz'
  sha1 '5fc7151a57b89c03d7b825df5a0fae0a8d5f05674c0e7cf2937ecec4d54a028c'

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
