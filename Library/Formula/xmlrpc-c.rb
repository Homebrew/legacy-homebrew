require 'brewkit'

class XmlrpcC <Formula
  @url='http://kent.dl.sourceforge.net/sourceforge/xmlrpc-c/xmlrpc-c-1.06.33.tgz'
  @md5='7dda4d8c5d26ae877d3809e428ce7962'
  @homepage='http://xmlrpc-c.sourceforge.net/'

  def install
    ENV.deparallelize
    # choosing --enable-libxml2-backend to lose some weight and not statically
    # link in expat
    #NOTE seemingly it isn't possible to build dylibs with this thing
    system "./configure --disable-debug --enable-libxml2-backend --prefix='#{prefix}'"
    system "make install"
  end
end