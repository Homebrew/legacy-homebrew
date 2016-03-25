class BbftpClient < Formula
  desc "Secure file transfer software, optimized for large files"
  homepage "http://doc.in2p3.fr/bbftp/"
  url "http://doc.in2p3.fr/bbftp/dist/bbftp-client-3.2.1.tar.gz"
  sha256 "4000009804d90926ad3c0e770099874084fb49013e8b0770b82678462304456d"
  revision 1

  bottle do
    sha256 "d813b37a04edcd071198dacd750fbac54fa3cd692fb7dda774aae88c5b8a2d9f" => :el_capitan
    sha256 "d1b3299d2308aac2881b5049e55e912e871e98fe44a4d3586ad6afc4a565d2e6" => :yosemite
    sha256 "8619a2f08f735d7e2387ba67ca53bf6f503f37835db08b127033d5c66019688d" => :mavericks
    sha256 "613133ffd2d9eb3d064a7ecfd12939655362d9d6f7c951f93260c0a47ddd835c" => :mountain_lion
  end

  depends_on "openssl"

  # Dirty patch to fix ntohll errors on Yosemite.
  # Reported upstream on 14/01/2015.
  patch :DATA if MacOS.version >= :yosemite

  def install
    cd "bbftpc" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--with-ssl=#{Formula["openssl"].opt_prefix}", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/bbftp", "-v"
  end
end

__END__

diff --git a/bbftpc/bbftp_get.c b/bbftpc/bbftp_get.c
index 96c8d35..b1cd2e3 100644
--- a/bbftpc/bbftp_get.c
+++ b/bbftpc/bbftp_get.c
@@ -94,9 +94,9 @@ extern  int     nbport ;
 extern  int     state ;
 extern  int     protocol ;

-#ifndef HAVE_NTOHLL
-my64_t ntohll(my64_t v) ;
-#endif
+// #ifndef HAVE_NTOHLL
+// my64_t ntohll(my64_t v) ;
+// #endif

 int bbftp_get(char *remotefilename,int  *errcode)
 {

diff --git a/bbftpc/bbftp_put.c b/bbftpc/bbftp_put.c
index 53c9919..b633ceb 100644
--- a/bbftpc/bbftp_put.c
+++ b/bbftpc/bbftp_put.c
@@ -96,9 +96,9 @@ extern  int     state ;
 extern  int     simulation_mode ;
 extern  int     protocol ;

-#ifndef HAVE_NTOHLL
-my64_t ntohll(my64_t v) ;
-#endif
+// #ifndef HAVE_NTOHLL
+// my64_t ntohll(my64_t v) ;
+// #endif

 int bbftp_put(char *remotefilename,int  *errcode)
 {

diff --git a/bbftpc/bbftp_utils.c b/bbftpc/bbftp_utils.c
index 40d5f9e..7143903 100644
--- a/bbftpc/bbftp_utils.c
+++ b/bbftpc/bbftp_utils.c
@@ -82,20 +82,20 @@ my64_t convertlong(my64_t v) {
     return tmp64 ;
 }

-#ifndef HAVE_NTOHLL
-my64_t ntohll(my64_t v) {
-#ifdef HAVE_BYTESWAP_H
-    return bswap_64(v);
-#else
-    long lo = v & 0xffffffff;
-    long hi = v >> 32U;
-    lo = ntohl(lo);
-    hi = ntohl(hi);
-    return ((my64_t) lo) << 32U | hi;
-#endif
-}
-#define htonll ntohll
-#endif
+// #ifndef HAVE_NTOHLL
+// my64_t ntohll(my64_t v) {
+// #ifdef HAVE_BYTESWAP_H
+//    return bswap_64(v);
+// #else
+//    long lo = v & 0xffffffff;
+//    long hi = v >> 32U;
+//    lo = ntohl(lo);
+//    hi = ntohl(hi);
+//    return ((my64_t) lo) << 32U | hi;
+// #endif
+// }
+// #define htonll ntohll
+// #endif

 void printmessage(FILE *strm , int flag, int errcode, int tok, char *fmt, ...)
 {
