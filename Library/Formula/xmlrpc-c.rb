require 'formula'

class XmlrpcC < Formula
  homepage 'http://xmlrpc-c.sourceforge.net/'
  url 'http://svn.code.sf.net/p/xmlrpc-c/code/stable', :revision => 2489
  version '1.33.03'

  def install
    ENV.deparallelize
    # --enable-libxml2-backend to lose some weight and not statically link in expat
    system "./configure", "--disable-debug",
                          "--enable-libxml2-backend",
                          "--prefix=#{prefix}"

    # xmlrpc-config.h cannot be found if only calling make install
    system "make"
    system "make install"
  end
end
