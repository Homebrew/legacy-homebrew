require 'formula'

class Xbfuse <Formula
  url 'http://multimedia.cx/xbfuse/xbfuse-1.0.tar.bz2'
  homepage 'http://multimedia.cx/xbfuse/'
  md5 '901b4ab4af09e19863be464e30fa7a5c'
  
  def patches
    # fixes builds on MacOS
    DATA
  end

  def install
    ENV.append 'CPPFLAGS', '-D__FreeBSD__=10 -D_FILE_OFFSET_BITS=64 -DFUSE_USE_VERSION=25'
    
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/src/tree.c b/src/tree.c
index de5863c..bd6bd76 100644
--- a/src/tree.c
+++ b/src/tree.c
@@ -24,6 +24,31 @@
 
 #include "tree.h"
 
+/* This is a workaround to built on MacOS X.
+ * See https://savannah.gnu.org/bugs/?24380
+ */
+#ifdef __APPLE__
+size_t strnlen(const char *s, size_t len) 
+{ 
+    size_t i; 
+    
+    for(i=0; i<len && *(s+i); i++); 
+    return i; 
+} 
+
+char* strndup (char const *s, size_t n) 
+{ 
+    size_t len = strnlen (s, n); 
+    char *new = malloc (len + 1); 
+
+    if (new == NULL) 
+        return NULL; 
+
+    new[len] = '\0'; 
+    return memcpy (new, s, len); 
+} 
+#endif
+
 void tree_insert(struct tree *root, const char *path, int length,
                 off_t offset, long size)
 {
