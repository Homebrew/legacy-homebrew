require 'formula'

class Tcpflow < Formula
  url 'http://www.circlemud.org/pub/jelson/tcpflow/tcpflow-0.21.tar.gz'
  homepage 'http://www.circlemud.org/~jelson/software/tcpflow/'
  md5 '45a5aef6f043312315b7f342afc4a9c5'

  def patches
    # Patch from MacPorts
    DATA
  end

  def install
    if MacOS.leopard?
      cp Dir["#{MacOS.xcode_prefix}/usr/share/libtool/config.*"], "."
    else
      cp Dir["#{MacOS.xcode_prefix}/usr/share/libtool/config/config.*"], "."
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end

__END__
--- a/src/util.c	2001-08-09 05:39:40.000000000 +1000
+++ b/src/util.c	2008-12-27 18:12:52.000000000 +1100
@@ -181,6 +181,12 @@ int get_max_fds(void)
       exit(1);
     }

+#if defined(__APPLE__)
+	if (limit.rlim_max > OPEN_MAX) {
+		limit.rlim_max = OPEN_MAX;
+	}
+#endif
+
     /* set the current to the maximum or specified value */
     if (max_desired_fds)
       limit.rlim_cur = max_desired_fds;

--- a/src/datalink.c	2002-03-29 18:19:03.000000000 -0500
+++ b/src/datalink.c	2010-08-06 17:40:55.000000000 -0400
@@ -42,6 +42,13 @@

 #include "tcpflow.h"

+/*
+ * Byte-swap a 32-bit number.
+ * ("htonl()" or "ntohl()" won't work - we want to byte-swap even on
+ * big-endian platforms.)
+ */
+#define SWAPLONG(y) \
+((((y)&0xff)<<24) | (((y)&0xff00)<<8) | (((y)&0xff0000)>>8) | (((y)>>24)&0xff))


 /* The DLT_NULL packet header is 4 bytes long. It contains a network
@@ -49,6 +49,9 @@
  * DLT_NULL is used by the localhost interface. */
 #define	NULL_HDRLEN 4

+/* loopback family */
+#define AF_LOOPBACK 0x2000000
+
 void dl_null(u_char *user, const struct pcap_pkthdr *h, const u_char *p)
 {
   u_int caplen = h->caplen;
@@ -71,7 +78,8 @@
 #ifndef DLT_NULL_BROKEN
   /* make sure this is AF_INET */
   memcpy((char *)&family, (char *)p, sizeof(family));
-  family = ntohl(family);
+  // family = ntohl(family);
+  if ((family & 0xFFFF0000) != 0) family = SWAPLONG(family);
   if (family != AF_INET) {
     DEBUG(6) ("warning: received non-AF_INET null frame (type %d)", family);
     return;
@@ -72,7 +75,7 @@
   /* make sure this is AF_INET */
   memcpy((char *)&family, (char *)p, sizeof(family));
   family = ntohl(family);
-  if (family != AF_INET) {
+  if (family != AF_INET && family != AF_LOOPBACK) {
     DEBUG(6) ("warning: received non-AF_INET null frame (type %d)", family);
     return;
   }
