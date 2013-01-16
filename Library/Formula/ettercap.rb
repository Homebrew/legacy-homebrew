require 'formula'

class Ettercap < Formula
  homepage 'http://ettercap.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/ettercap/ettercap/0.7.5-Assimilation/ettercap-0.7.5.1.tar.gz'
  sha1 '912394ce37479099402281030b472bc92a5d6db6'

  depends_on 'cmake' => :build
  depends_on 'ghostscript' => :build
  depends_on 'pcre'
  depends_on 'libnet'
  depends_on 'curl' # require libcurl >= 7.26.0

  # Solve incompatible return types.
  # Patch forwarded upstream: https://github.com/Ettercap/ettercap/pull/66
  # Merge upstream fix for CVE-2012-0722: https://github.com/Ettercap/ettercap/pull/68
  # Both patch already merged upstream. Drop on next major version.
  def patches; DATA; end

  def install
    libnet = Formula.factory 'libnet'

    args = ['..'] + std_cmake_args + [
      "-DINSTALL_SYSCONFDIR=#{etc}",
      '-DENABLE_GTK=OFF',
      "-DHAVE_LIBNET:FILEPATH=#{libnet.opt_prefix}/lib/libnet.dylib"
    ]

    mkdir "build" do
      system "cmake", *args
      system "make install"
    end
  end
end

__END__
diff --git a/src/dissectors/ec_mongodb.c b/src/dissectors/ec_mongodb.c
index 86ebbdd..297e8d7 100644
--- a/src/dissectors/ec_mongodb.c
+++ b/src/dissectors/ec_mongodb.c
@@ -99,7 +99,7 @@ FUNC_DECODER(dissector_mongodb)
               if (session_get(&s, ident, DISSECT_IDENT_LEN) == ESUCCESS) {
                       conn_status = (struct mongodb_status *) s->data;
                       if (PACKET->DATA.len < 16)
-                              return;
+                              return NULL;
                       unsigned char *res = memmem(ptr, PACKET->DATA.len, "fails", 5);
                       unsigned char *gres = memmem(ptr, PACKET->DATA.len, "readOnly", 8);
                       if (conn_status->status == WAIT_RESULT && res) {
@@ -118,7 +118,7 @@ FUNC_DECODER(dissector_mongodb)
       if (session_get(&s, ident, DISSECT_IDENT_LEN) == ESUCCESS) {
          conn_status = (struct mongodb_status *) s->data;
          if (PACKET->DATA.len < 16)
-                 return;
+                 return NULL;
 
          unsigned char *noncep  = memmem(ptr, PACKET->DATA.len, "nonce", 5);
          unsigned char *keyp  = memmem(ptr, PACKET->DATA.len, "key\x00", 4);
diff --git a/include/ec.h b/include/ec.h
index 463e36f..069e3f1 100644
--- a/include/ec.h
+++ b/include/ec.h
@@ -81,6 +81,11 @@
 
 #define SAFE_FREE(x) do{ if(x) { free(x); x = NULL; } }while(0)
 
+
+/* convert to string */
+#define EC_STRINGIFY(in) #in
+#define EC_TOSTRING(in) EC_STRINGIFY(in)
+
 #ifdef OS_LINUX
 #define __init       __attribute__((constructor(101)))
 #define __init_last  __attribute__((constructor(200))
diff --git a/include/ec_inet.h b/include/ec_inet.h
index 43b0ca5..379192d 100644
--- a/include/ec_inet.h
+++ b/include/ec_inet.h
@@ -24,24 +24,22 @@
    #endif
 #endif
 
-enum {
-   NS_IN6ADDRSZ            = 16,
-   NS_INT16SZ              = 2,
-
-   ETH_ADDR_LEN            = 6,
-   TR_ADDR_LEN             = 6,
-   FDDI_ADDR_LEN           = 6,
-   MEDIA_ADDR_LEN          = 6,
+#define	NS_IN6ADDRSZ 16
+#define 	NS_INT16SZ = 2
+
+#define	ETH_ADDR_LEN 6
+#define	TR_ADDR_LEN 6
+#define	FDDI_ADDR_LEN 6
+#define	MEDIA_ADDR_LEN 6
    
-   IP_ADDR_LEN             = 4,
-   IP6_ADDR_LEN            = 16,
-   MAX_IP_ADDR_LEN         = IP6_ADDR_LEN,
-
-   ETH_ASCII_ADDR_LEN      = sizeof("ff:ff:ff:ff:ff:ff")+1,
-   IP_ASCII_ADDR_LEN       = sizeof("255.255.255.255")+1,
-   IP6_ASCII_ADDR_LEN      = sizeof("ffff:ffff:ffff:ffff:ffff:ffff:255.255.255.255")+1,
-   MAX_ASCII_ADDR_LEN      = IP6_ASCII_ADDR_LEN,                  
-};
+#define	IP_ADDR_LEN 4
+#define	IP6_ADDR_LEN 16
+#define	MAX_IP_ADDR_LEN IP6_ADDR_LEN
+
+#define	ETH_ASCII_ADDR_LEN 19 // sizeof("ff:ff:ff:ff:ff:ff")+1
+#define	IP_ASCII_ADDR_LEN 17 // sizeof("255.255.255.255")+1
+#define	IP6_ASCII_ADDR_LEN 47 // sizeof("ffff:ffff:ffff:ffff:ffff:ffff:255.255.255.255")+1
+#define	MAX_ASCII_ADDR_LEN IP6_ASCII_ADDR_LEN
 
 /*
  * Some predefined addresses here
diff --git a/src/ec_scan.c b/src/ec_scan.c
index cce3672..9455c3e 100644
--- a/src/ec_scan.c
+++ b/src/ec_scan.c
@@ -630,7 +630,7 @@ int scan_load_hosts(char *filename)
    for (nhosts = 0; !feof(hf); nhosts++) {
       int proto;
 
-      if (fscanf(hf, "%s %s %s\n", ip, mac, name) != 3 ||
+      if (fscanf(hf, "%"EC_TOSTRING(MAX_ASCII_ADDR_LEN)"s %"EC_TOSTRING(ETH_ASCII_ADDR_LEN)"s %"EC_TOSTRING(MAX_HOSTNAME_LEN)"s\n", ip, mac, name) != 3 ||
          *ip == '#' || *mac == '#' || *name == '#')
          continue;
 
