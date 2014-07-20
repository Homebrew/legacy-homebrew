require 'formula'

class Libxslt < Formula
  homepage 'http://xmlsoft.org/XSLT/'
  url 'ftp://xmlsoft.org/libxml2/libxslt-1.1.28.tar.gz'
  mirror 'http://xmlsoft.org/sources/libxslt-1.1.28.tar.gz'
  sha1 '4df177de629b2653db322bfb891afa3c0d1fa221'

  bottle do
    sha1 "c4d074b187410fd61717eeefb3223dbcea0238e9" => :mavericks
    sha1 "f48d9e65910f3749ddb31245455233f5195884d0" => :mountain_lion
    sha1 "7ec19f550aaecb6098c2cdadb19177232b5fc07f" => :lion
  end

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
