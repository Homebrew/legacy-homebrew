require 'formula'

class Tcpflow <Formula
  url 'http://www.circlemud.org/pub/jelson/tcpflow/tcpflow-0.21.tar.gz'
  homepage 'http://www.circlemud.org/~jelson/software/tcpflow/'
  md5 '45a5aef6f043312315b7f342afc4a9c5'

  def patches
    # Patch from MacPorts
    DATA
  end

  def install
    where = `xcode-select --print-path`.chomp
    cp Dir["#{where}/usr/share/libtool/config/config.*"], "."

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
@@ -49,6 +49,9 @@
  * DLT_NULL is used by the localhost interface. */
 #define	NULL_HDRLEN 4
 
+/* loopback family */
+#define AF_LOOPBACK 0x2000000
+
 void dl_null(u_char *user, const struct pcap_pkthdr *h, const u_char *p)
 {
   u_int caplen = h->caplen;
@@ -72,7 +75,7 @@
   /* make sure this is AF_INET */
   memcpy((char *)&family, (char *)p, sizeof(family));
   family = ntohl(family);
-  if (family != AF_INET) {
+  if (family != AF_INET && family != AF_LOOPBACK) {
     DEBUG(6) ("warning: received non-AF_INET null frame (type %d)", family);
     return;
   }
