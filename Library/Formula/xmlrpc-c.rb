require 'formula'

class XmlrpcC < Formula
  homepage 'http://xmlrpc-c.sourceforge.net/'
  url 'http://downloads.sourceforge.net/sourceforge/xmlrpc-c/xmlrpc-c-1.16.44.tgz'
  sha1 '181c54ac860698ed7cf4e3814c6f3c6dd46b2ce1'

  def patches
    # Backport patch for deprecated curl/types.h include, which is gone on 10.8
    # On 10.6 and 10.7 it's empty, so could probably patch unconditionally
    # see http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=636457#10
    DATA if MacOS.version >= :mountain_lion
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

__END__
--- stable/lib/curl_transport/curltransaction.c 2011/03/26 19:32:28 2115
+++ stable/lib/curl_transport/curltransaction.c 2011/07/09 17:47:44 2150
@@ -17,7 +17,9 @@
 #include "version.h"
 
 #include <curl/curl.h>
+#ifdef NEED_CURL_TYPES_H
 #include <curl/types.h>
+#endif
 #include <curl/easy.h>
 
 #include "curlversion.h"
--- stable/lib/curl_transport/curlmulti.c 2011/07/09 17:41:18 2149
+++ stable/lib/curl_transport/curlmulti.c 2011/07/09 17:47:44 2150
@@ -19,7 +19,9 @@
 #endif
 
 #include <curl/curl.h>
+#ifdef NEED_CURL_TYPES_H
 #include <curl/types.h>
+#endif
 #include <curl/easy.h>
 #include <curl/multi.h>
 
--- stable/lib/curl_transport/xmlrpc_curl_transport.c 2011/07/09 17:41:18 2149
+++ stable/lib/curl_transport/xmlrpc_curl_transport.c 2011/07/09 17:47:44 2150
@@ -85,7 +85,9 @@
 #include "xmlrpc-c/time_int.h"
 
 #include <curl/curl.h>
+#ifdef NEED_CURL_TYPES_H
 #include <curl/types.h>
+#endif
 #include <curl/easy.h>
 #include <curl/multi.h>
