require 'formula'

class Pjsip < Formula
  homepage 'http://www.pjsip.org'
  url 'http://www.pjsip.org/release/2.1/pjproject-2.1.tar.bz2'
  sha1 '244884fb900594104792c431946384e0fedc9560'

  # 1. We aren't cross compiling
  #    pjsip thinks we are, this is fixed somewhere between revision 4305 and
  #    4621. This should be removed when this formula is updated to 2.2.
  # 2, 3. Clang compatibility
  #    This is fixed in revision 4588 and should be removed when this formula
  #    is updated to 2.2. http://trac.pjsip.org/repos/ticket/1576
  patch :DATA

  def install
    ENV.j1
    system "./configure", "--prefix=#{prefix}"
    Pathname('pjlib/include/pj/config_site.h').write <<-EOS.undent
      #define PJ_CONFIG_MAXIMUM_SPEED
      #include <pj/config_site_sample.h>

      #ifndef FD_SETSIZE
        #include <sys/types.h>
      #endif

      #if PJ_IOQUEUE_MAX_HANDLES>FD_SETSIZE
        #undef PJ_IOQUEUE_MAX_HANDLES
        #define PJ_IOQUEUE_MAX_HANDLES     FD_SETSIZE
      #endif

      #define PJSUA_MAX_CALLS              1024
      #define PJSUA_MAX_PLAYERS            1024
      #define PJSUA_MAX_RECORDERS          1024
      #define PJSUA_MAX_CONF_PORTS         (PJSUA_MAX_CALLS+PJSUA_MAX_PLAYERS+PJSUA_MAX_RECORDERS)
    EOS
    system "make", "dep"
    system "make"
    system "make", "install"
  end
end

__END__
--- a/aconfigure
+++ b/aconfigure
@@ -3526,7 +3526,7 @@


 if test -z "$CROSS_COMPILE"; then
-    CROSS_COMPILE=`echo ${CC} | sed 's/gcc//'`
+    CROSS_COMPILE=
 fi

 if test "$AR" = ""; then AR="${CROSS_COMPILE}ar rv"; fi
--- a/third_party/srtp/crypto/cipher/aes_icm.c
+++ b/third_party/srtp/crypto/cipher/aes_icm.c
@@ -284,5 +284,5 @@
  */

-inline void
+static inline void
 aes_icm_advance_ismacryp(aes_icm_ctx_t *c, uint8_t forIsmacryp) {
   /* fill buffer with new keystream */
--- a/third_party/srtp/crypto/math/datatypes.c
+++ b/third_party/srtp/crypto/math/datatypes.c
@@ -125,5 +125,5 @@
 }

-inline int
+static inline int
 hex_char_to_nibble(uint8_t c) {
   switch(c) {
