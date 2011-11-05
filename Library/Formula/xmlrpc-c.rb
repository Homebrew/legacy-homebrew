require 'formula'

class XmlrpcC < Formula
  url 'http://downloads.sourceforge.net/sourceforge/xmlrpc-c/xmlrpc-c-1.16.38.tgz'
  md5 'fabb49e5f1efeffa1bedd15a9131699a'
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
