require 'formula'

class XmlrpcC < Formula
  homepage 'http://xmlrpc-c.sourceforge.net/'
  url 'http://downloads.sourceforge.net/sourceforge/xmlrpc-c/xmlrpc-c-1.16.42.tgz'
  sha1 '7a71fabc652c2848a7226605432a2e420a02dff0'

  def patches
    # Disable including deprecated curl/types.h, which is missing on 10.8
    # On 10.6 and 10.7 it's empty, so could probably patch unconditionally
    # see http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=636457#10
    if MacOS.mountain_lion?
      "http://xmlrpc-c.svn.sourceforge.net/viewvc/xmlrpc-c/stable/lib/curl_transport/xmlrpc_curl_transport.c?r1=2115&r2=2150&view=patch"
    end
  end

  def install
    ENV.deparallelize
    # --enable-libxml2-backend to lose some weight and not statically link in expat
    system "./configure", "--disable-debug",
                          "--enable-libxml2-backend",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
