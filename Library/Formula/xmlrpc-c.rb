require 'formula'

class XmlrpcC < Formula
  homepage 'http://xmlrpc-c.sourceforge.net/'
  url 'http://downloads.sourceforge.net/sourceforge/xmlrpc-c/xmlrpc-c-1.16.39.tgz'
  md5 'e88c9ee202890d726405b3bdfb00cfaf'

  def install
    ENV.deparallelize
    # choosing --enable-libxml2-backend to lose some weight and not statically
    # link in expat
    # NOTE seemingly it isn't possible to build dylibs with this thing
    system "./configure", "--disable-debug", "--enable-libxml2-backend", "--prefix=#{prefix}"
    system "make install"
  end
end
