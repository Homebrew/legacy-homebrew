require 'formula'

class Libmikmod < Formula
  url 'http://mikmod.raphnet.net/files/libmikmod-3.2.0-beta2.tar.bz2'
  homepage 'http://mikmod.raphnet.net/'
  md5 '5b05f3b1167eba7855b8e38bde2b8070'

  # MacPorts patches to fix broken audio in 64-bit, crash on accessing samples menu
  def patches
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make install"
  end
end


__END__
diff --git a/include/mikmod.h.in b/include/mikmod.h.in
index 9b98f43..c39f779 100644
--- a/include/mikmod.h.in
+++ b/include/mikmod.h.in
@@ -85,7 +85,7 @@ typedef char CHAR;
 
 @DOES_NOT_HAVE_SIGNED@
 
-#if defined(__arch64__) || defined(__alpha)
+#if defined(__arch64__) || defined(__alpha) || defined(_LP64)
 /* 64 bit architectures */
 
 typedef signed char     SBYTE;      /* 1 byte, signed */
diff --git a/include/mikmod_internals.h b/include/mikmod_internals.h
index c61dab1..4fab08d 100644
--- a/include/mikmod_internals.h
+++ b/include/mikmod_internals.h
@@ -50,7 +50,7 @@ extern "C" {
 /*========== More type definitions */
 
 /* SLONGLONG: 64bit, signed */
-#if defined (__arch64__) || defined(__alpha)
+#if defined(__arch64__) || defined(__alpha) || defined(_LP64)
 typedef long		SLONGLONG;
 #define NATIVE_64BIT_INT
 #elif defined(__WATCOMC__)
diff --git a/playercode/virtch_common.c b/playercode/virtch_common.c
index 17ffaac..9b4f976 100644
--- a/playercode/virtch_common.c
+++ b/playercode/virtch_common.c
@@ -351,7 +351,7 @@ void VC1_VoiceSetPanning(UBYTE voice,ULONG pan)
 
 void VC1_SampleUnload(SWORD handle)
 {
-	if (handle<MAXSAMPLEHANDLES) {
+	if (Samples && handle<MAXSAMPLEHANDLES) {
 		if (Samples[handle])
 			free(Samples[handle]);
 		Samples[handle]=NULL;
