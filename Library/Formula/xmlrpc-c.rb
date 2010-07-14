require 'formula'

class XmlrpcC <Formula
  url 'http://downloads.sourceforge.net/sourceforge/xmlrpc-c/xmlrpc-c-1.06.39.tgz'
  md5 'ec62fb15cca83ffeaf6a8d53b5ec8614'
  homepage 'http://xmlrpc-c.sourceforge.net/'

  def install
    ENV.deparallelize
    # choosing --enable-libxml2-backend to lose some weight and not statically
    # link in expat
    #NOTE seemingly it isn't possible to build dylibs with this thing
    system "./configure", "--disable-debug", "--enable-libxml2-backend", "--prefix=#{prefix}"
    system "make install"
  end
end