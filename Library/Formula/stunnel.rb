require 'formula'

class Stunnel < Formula
  url 'ftp://ftp.stunnel.org/stunnel/stunnel-4.36.tar.gz'
  homepage 'http://www.stunnel.org/'
  md5 '600a09b03798424842b24548ca1e4235'

  # This patch installs a bogus .pem in lieu of interactive cert generation.
  # It also patches str.c so it can be compiled on OS X:
  # https://groups.google.com/group/mailing.unix.stunnel-users/browse_thread/thread/043d6bc93fcb098b
  # This patch was provided by the author, and may not be needed in 4.37
  def patches
    DATA
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-libwrap",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
                          "--mandir=#{man}"
    system "make install"
  end

  def caveats
    <<-EOS.undent
      A bogus SSL server certificate has been installed to:
        #{etc}/stunnel/stunnel.pem

      This certificate will be used by default unless a config file says otherwise!

      In your stunnel configuration, specify a SSL certificate with
      the "cert =" option for each service.
    EOS
  end
end


__END__
diff --git a/tools/stunnel.cnf b/tools/stunnel.cnf
index 274f9a0..d5d7cc0 100644
--- a/tools/stunnel.cnf
+++ b/tools/stunnel.cnf
@@ -7,6 +7,7 @@ default_bits = 1024
 encrypt_key = yes
 distinguished_name = req_dn
 x509_extensions = cert_type
+prompt = no
 
 [ req_dn ]
 countryName = Country Name (2 letter code)

--- a/src/str.c	2011-05-02 19:14:53.000000000 +0200
+++ b/src/str.c	2011-05-10 17:34:40.000000000 +0200
@@ -38,17 +38,128 @@
 #include "common.h"
 #include "prototypes.h"
 
-typedef struct str_struct {
-    struct str_struct *prev, *next;
+#ifndef va_copy
+#ifdef __va_copy
+#define va_copy(dst, src) __va_copy((dst), (src))
+#else /* __va_copy */
+#define va_copy(dst, src) memcpy(&(dst), &(src), sizeof(va_list))
+#endif /* __va_copy */
+#endif /* va_copy */
+
+typedef struct alloc_list {
+    struct alloc_list *prev, *next;
     size_t size;
     unsigned int magic;
-} STR;
-static void str_set(STR *);
-static STR *str_get();
+} ALLOC_LIST;
+
+static void set_alloc_head(ALLOC_LIST *);
+static ALLOC_LIST *get_alloc_head();
+
+char *str_dup(const char *str) {
+    char *retval;
+
+    retval=str_alloc(strlen(str)+1);
+    if(retval)
+        strcpy(retval, str);
+    return retval;
+}
+
+char *str_printf(const char *format, ...) {
+    char *txt;
+    va_list arglist;
+
+    va_start(arglist, format);
+    txt=str_vprintf(format, arglist);
+    va_end(arglist);
+    return txt;
+}
+
+char *str_vprintf(const char *format, va_list start_ap) {
+    int n, size=64;
+    char *p, *np;
+    va_list ap;
+
+    p=str_alloc(size);
+    if(!p)
+        return NULL;
+    for(;;) {
+        va_copy(ap, start_ap);
+        n=vsnprintf(p, size, format, ap);
+        if(n>-1 && n<size)
+            return p;
+        if(n>-1)      /* glibc 2.1 */
+            size=n+1; /* precisely what is needed */
+        else          /* glibc 2.0, WIN32, etc. */
+            size*=2;  /* twice the old size */
+        np=str_realloc(p, size);
+        if(!np) {
+            str_free(p);
+            return NULL;
+        }
+        p=np; /* LOL */
+    }
+}
+
+#ifdef USE_UCONTEXT
+
+static ALLOC_LIST *alloc_tls=NULL;
+
+void str_init() {
+}
+
+static void set_alloc_head(ALLOC_LIST *alloc_head) {
+    if(ready_head)
+        ready_head->tls=alloc_head;
+    else /* ucontext threads not initialized */
+        alloc_tls=alloc_head;
+}
+
+static ALLOC_LIST *get_alloc_head() {
+    if(ready_head)
+        return ready_head->tls;
+    else /* ucontext threads not initialized */
+        return alloc_tls;
+}
+
+#endif /* USE_UCONTEXT */
+
+#ifdef USE_FORK
+
+static ALLOC_LIST *alloc_tls=NULL;
+
+void str_init() {
+}
+
+static void set_alloc_head(ALLOC_LIST *alloc_head) {
+    alloc_tls=alloc_head;
+}
+
+static ALLOC_LIST *get_alloc_head() {
+    return alloc_tls;
+}
+
+#endif /* USE_FORK */
+
+#ifdef USE_PTHREAD
+
+static pthread_key_t pthread_key;
+
+void str_init() {
+    pthread_key_create(&pthread_key, NULL);
+}
+
+static void set_alloc_head(ALLOC_LIST *alloc_head) {
+    pthread_setspecific(pthread_key, alloc_head);
+}
+
+static ALLOC_LIST *get_alloc_head() {
+    return pthread_getspecific(pthread_key);
+}
+
+#endif /* USE_PTHREAD */
 
 #ifdef USE_WIN32
 
-/* __thread does not work in mingw32 due to a bug in GCC */
 static DWORD tls_index; 
 
 void str_init() {
@@ -59,61 +170,43 @@
     }
 }
 
-static void str_set(STR *str) {
-    if(!TlsSetValue(tls_index, str)) {
+static void set_alloc_head(ALLOC_LIST *alloc_head) {
+    if(!TlsSetValue(tls_index, alloc_head)) {
         s_log(LOG_ERR, "TlsSetValue failed");
         die(1);
     }
 }
 
-static STR *str_get() {
-    STR *str;
+static ALLOC_LIST *get_alloc_head() {
+    ALLOC_LIST *alloc_head;
 
-    str=TlsGetValue(tls_index);
-    if(!str && GetLastError()!=ERROR_SUCCESS) {
+    alloc_head=TlsGetValue(tls_index);
+    if(!alloc_head && GetLastError()!=ERROR_SUCCESS) {
         s_log(LOG_ERR, "TlsGetValue failed");
         die(1);
     }
-    return str;
-}
-
-#else
-
-/* gcc Thread-Local Storage */
-static __thread STR *root_str=NULL;
-
-void str_init() {
-    if(root_str)
-        s_log(LOG_WARNING, "str_init: Non-empty allocation list");
+    return alloc_head;
 }
 
-static void str_set(STR *str) {
-    root_str=str;
-}
-
-static STR *str_get() {
-    return root_str;
-}
-
-#endif
+#endif /* USE_WIN32 */
 
 void str_cleanup() {
-    STR *str, *tmp;
+    ALLOC_LIST *alloc_head, *tmp;
 
-    str=str_get();
-    while(str) {
-        tmp=str;
-        str=tmp->next;
+    alloc_head=get_alloc_head();
+    while(alloc_head) {
+        tmp=alloc_head;
+        alloc_head=tmp->next;
         free(tmp);
     }
-    str_set(NULL);
+    set_alloc_head(NULL);
 }
 
 void str_stats() {
-    STR *tmp;
+    ALLOC_LIST *tmp;
     int blocks=0, bytes=0;
 
-    for(tmp=str_get(); tmp; tmp=tmp->next) {
+    for(tmp=get_alloc_head(); tmp; tmp=tmp->next) {
         ++blocks;
         bytes+=tmp->size;
     }
@@ -121,35 +214,37 @@
 }
 
 void *str_alloc(size_t size) {
-    STR *str, *tmp;
+    ALLOC_LIST *alloc_head, *tmp;
 
     if(size>=1024*1024) /* huge allocations are not allowed */
         return NULL;
-    tmp=calloc(1, sizeof(STR)+size);
+    tmp=calloc(1, sizeof(ALLOC_LIST)+size);
     if(!tmp)
         return NULL;
-    str=str_get();
+    alloc_head=get_alloc_head();
     tmp->prev=NULL;
-    tmp->next=str;
+    tmp->next=alloc_head;
     tmp->size=size;
     tmp->magic=0xdeadbeef;
-    if(str)
-        str->prev=tmp;
-    str_set(tmp);
+    if(alloc_head)
+        alloc_head->prev=tmp;
+    set_alloc_head(tmp);
     return tmp+1;
 }
 
 void *str_realloc(void *ptr, size_t size) {
-    STR *oldtmp, *tmp;
+    ALLOC_LIST *old_tmp, *tmp;
 
     if(!ptr)
         return str_alloc(size);
-    oldtmp=(STR *)ptr-1;
-    if(oldtmp->magic!=0xdeadbeef) { /* not allocated by str_alloc() */
+    old_tmp=(ALLOC_LIST *)ptr-1;
+    if(old_tmp->magic!=0xdeadbeef) { /* not allocated by str_alloc() */
         s_log(LOG_CRIT, "INTERNAL ERROR: str_realloc: Bad magic");
         die(1);
     }
-    tmp=realloc(oldtmp, sizeof(STR)+size);
+    if(size>=1024*1024) /* huge allocations are not allowed */
+        return NULL;
+    tmp=realloc(old_tmp, sizeof(ALLOC_LIST)+size);
     if(!tmp)
         return NULL;
     /* refresh all possibly invalidated pointers */
@@ -158,17 +253,17 @@
     if(tmp->prev)
         tmp->prev->next=tmp;
     tmp->size=size;
-    if(str_get()==oldtmp)
-        str_set(tmp);
+    if(get_alloc_head()==old_tmp)
+        set_alloc_head(tmp);
     return tmp+1;
 }
 
 void str_free(void *ptr) {
-    STR *tmp;
+    ALLOC_LIST *tmp;
 
     if(!ptr) /* do not attempt to free null pointers */
         return;
-    tmp=(STR *)ptr-1;
+    tmp=(ALLOC_LIST *)ptr-1;
     if(tmp->magic!=0xdeadbeef) { /* not allocated by str_alloc() */
         s_log(LOG_CRIT, "INTERNAL ERROR: str_free: Bad magic");
         die(1);
@@ -178,54 +273,9 @@
         tmp->next->prev=tmp->prev;
     if(tmp->prev)
         tmp->prev->next=tmp->next;
-    if(str_get()==tmp)
-        str_set(tmp->next);
+    if(get_alloc_head()==tmp)
+        set_alloc_head(tmp->next);
     free(tmp);
 }
 
-char *str_dup(const char *str) {
-    char *retval;
-
-    retval=str_alloc(strlen(str)+1);
-    if(retval)
-        strcpy(retval, str);
-    return retval;
-}
-
-char *str_vprintf(const char *format, va_list start_ap) {
-    int n, size=64;
-    char *p, *np;
-    va_list ap;
-
-    p=str_alloc(size);
-    if(!p)
-        return NULL;
-    for(;;) {
-        va_copy(ap, start_ap);
-        n=vsnprintf(p, size, format, ap);
-        if(n>-1 && n<size)
-            return p;
-        if(n>-1)      /* glibc 2.1 */
-            size=n+1; /* precisely what is needed */
-        else          /* glibc 2.0 */
-            size*=2;  /* twice the old size */
-        np=str_realloc(p, size);
-        if(!np) {
-            str_free(p);
-            return NULL;
-        }
-        p=np; /* LOL */
-    }
-}
-
-char *str_printf(const char *format, ...) {
-    char *txt;
-    va_list arglist;
-
-    va_start(arglist, format);
-    txt=str_vprintf(format, arglist);
-    va_end(arglist);
-    return txt;
-}
-
 /* end of str.c */
