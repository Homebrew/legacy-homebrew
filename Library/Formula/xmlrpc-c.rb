require 'formula'

class XmlrpcC < Formula
  url 'http://downloads.sourceforge.net/sourceforge/xmlrpc-c/xmlrpc-c-1.16.34.tgz'
  md5 '41347f56aca5806e81164d3470812918'
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
