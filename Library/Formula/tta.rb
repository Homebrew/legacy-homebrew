require "formula"

class Tta < Formula
  homepage "http://www.true-audio.com"
  url "https://downloads.sourceforge.net/project/tta/tta/libtta/libtta-2.1.tar.gz"
  sha1 "2bd457131e2fc12b1d48a9e2b593a8c9f238837b"

  # Warning: This patch includes Windows-style line endings.
  # Be very careful when editing, as if they are not present, the patch will fail.
  #
  # Fix malloc location in libtta.h
  # Fix usage of lseek64 by defining lseek64 with lseek in console/tta.h
  # Fix SSE4 library header and inline functions in filter.h
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-sse4"
    system "make", "install"
  end
end

__END__
diff --git a/console/tta.h b/console/tta.h
index fc0aa74..f617d72 100644
--- a/console/tta.h
+++ b/console/tta.h
@@ -58,6 +58,7 @@ typedef RMfile (HANDLE);
 #else // NOT CARIBBEAN
 typedef int (HANDLE);
 #define INVALID_HANDLE_VALUE (-1)
+#define lseek64(__handle, __offset, __seek) lseek(__handle, __offset, __seek)
 #define tta_open_read(__name) open(__name,O_RDONLY|O_NONBLOCK)
 #define tta_open_write(__name) open(__name,O_RDWR|O_TRUNC|O_CREAT)
 #define tta_close(__handle) close(__handle)
diff --git a/filter.h b/filter.h
index 194cc80..0ef3488 100644
--- a/filter.h
+++ b/filter.h
@@ -19,7 +19,7 @@
 #elif defined(ENABLE_SSE2) || defined(ENABLE_SSE4)
 
 #if defined(ENABLE_SSE4)
-#include <tmmintrin.h>
+#include <smmintrin.h>
 #define mullo_epi32(a, b) _mm_mullo_epi32(a, b)
 #else // ENABLE_SSE2
 #include <emmintrin.h>
@@ -32,7 +32,7 @@
 ////////////////////////// hybrid_filter_sse4_dec ///////////////////////////
 /////////////////////////////////////////////////////////////////////////////
 
-__inline void hybrid_filter_dec(TTA_fltst *fs, TTAint32 *in) {
+static inline void hybrid_filter_dec(TTA_fltst *fs, TTAint32 *in) {
 	register TTAint32 *pA = fs->dl;
 	register TTAint32 *pB = fs->qm;
 	register TTAint32 *pM = fs->dx;
@@ -82,7 +82,7 @@ __inline void hybrid_filter_dec(TTA_fltst *fs, TTAint32 *in) {
 ////////////////////////// hybrid_filter_sse4_enc ///////////////////////////
 /////////////////////////////////////////////////////////////////////////////
 
-__inline void hybrid_filter_enc(TTA_fltst *fs, TTAint32 *in) {
+static inline void hybrid_filter_enc(TTA_fltst *fs, TTAint32 *in) {
 	register TTAint32 *pA = fs->dl;
 	register TTAint32 *pB = fs->qm;
 	register TTAint32 *pM = fs->dx;
@@ -134,7 +134,7 @@ __inline void hybrid_filter_enc(TTA_fltst *fs, TTAint32 *in) {
 ///////////////////////// hybrid_filter_compat_dec //////////////////////////
 /////////////////////////////////////////////////////////////////////////////
 
-__inline void hybrid_filter_dec(TTA_fltst *fs, TTAint32 *in) {
+static inline void hybrid_filter_dec(TTA_fltst *fs, TTAint32 *in) {
 	register TTAint32 *pA = fs->dl;
 	register TTAint32 *pB = fs->qm;
 	register TTAint32 *pM = fs->dx;
@@ -170,7 +170,7 @@ __inline void hybrid_filter_dec(TTA_fltst *fs, TTAint32 *in) {
 ///////////////////////// hybrid_filter_compat_enc //////////////////////////
 /////////////////////////////////////////////////////////////////////////////
 
-__inline void hybrid_filter_enc(TTA_fltst *fs, TTAint32 *in) {
+static inline void hybrid_filter_enc(TTA_fltst *fs, TTAint32 *in) {
 	register TTAint32 *pA = fs->dl;
 	register TTAint32 *pB = fs->qm;
 	register TTAint32 *pM = fs->dx;
diff --git a/libtta.h b/libtta.h
index 2443010..1c67d6f 100644
--- a/libtta.h
+++ b/libtta.h
@@ -18,7 +18,7 @@
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h> 
-#include <malloc.h> 
+#include <malloc/malloc.h> 
 
 #ifdef CARIBBEAN
 #define ALLOW_OS_CODE 1
