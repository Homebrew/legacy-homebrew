require 'formula'

class XmlrpcC < Formula
  homepage 'http://xmlrpc-c.sourceforge.net/'
  url 'http://downloads.sourceforge.net/sourceforge/xmlrpc-c/xmlrpc-c-1.16.42.tgz'
  sha1 '7a71fabc652c2848a7226605432a2e420a02dff0'

  def install
    ENV.deparallelize
    # --enable-libxml2-backend to lose some weight and not statically link in expat
    system "./configure", "--disable-debug",
                          "--enable-libxml2-backend",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
