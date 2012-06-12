require 'formula'

class XmlrpcC < Formula
  homepage 'http://xmlrpc-c.sourceforge.net/'
  url 'http://downloads.sourceforge.net/sourceforge/xmlrpc-c/xmlrpc-c-1.16.41.tgz'
  sha1 'aee10abad995ff745d10223b7335c374a931aa1f'

  def install
    ENV.deparallelize
    # --enable-libxml2-backend to lose some weight and not statically link in expat
    system "./configure", "--disable-debug",
                          "--enable-libxml2-backend",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
