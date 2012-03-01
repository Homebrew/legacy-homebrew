require 'formula'

class Rpm < Formula
  url 'http://rpm.org/releases/rpm-4.9.x/rpm-4.9.1.2.tar.bz2'
  homepage 'http://www.rpm.org/'
  md5 '85cc5b7adb5806b5abf5b538b088dbdc'

  depends_on 'nss'
  depends_on 'nspr'
  depends_on 'libmagic'
  depends_on 'popt'
  depends_on 'lua'
  depends_on 'berkeley-db'

  def patches
    DATA
  end

  def install
    # Note - MacPorts also builds without optimizations. This seems to fix several
    # random crashes
    ENV.append 'CPPFLAGS', "-I#{HOMEBREW_PREFIX}/include/nss -I#{HOMEBREW_PREFIX}/include/nspr"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "--with-external-db", "--sysconfdir=#{HOMEBREW_PREFIX}/etc", "--disable-optimize", "--without-javaglue", "--without-apidocs", "--enable-python", "--localstatedir=#{HOMEBREW_PREFIX}/var"
    system "make"
    system "make install"
  end
end

__END__
diff --git a/lib/poptALL.c b/lib/poptALL.c
index 474af33..535e564 100644
--- a/lib/poptALL.c
+++ b/lib/poptALL.c
@@ -246,7 +246,7 @@ rpmcliInit(int argc, char *const argv[], struct poptOption * optionsTable)
 #if HAVE_MCHECK_H && HAVE_MTRACE
     mtrace();   /* Trace malloc only if MALLOC_TRACE=mtrace-output-file. */
 #endif
-    setprogname(argv[0]);       /* Retrofit glibc __progname */
+    xsetprogname(argv[0]);       /* Retrofit glibc __progname */
 
     /* XXX glibc churn sanity */
     if (__progname == NULL) {
diff --git a/lib/rpmgi.c b/lib/rpmgi.c
index 19f8f9f..1f15313 100644
--- a/lib/rpmgi.c
+++ b/lib/rpmgi.c
@@ -45,7 +45,7 @@ static FD_t rpmgiOpen(const char * path, const char * fmode)
     char * fn = rpmExpand(path, NULL);
     FD_t fd = Fopen(fn, fmode);
 
-    if (fd == NULL || Ferror(fd)) {
+    if (fd == NULL) {
 	rpmlog(RPMLOG_ERR, _("open of %s failed: %s\n"), fn, Fstrerror(fd));
 	if (fd != NULL) (void) Fclose(fd);
 	fd = NULL;
diff --git a/misc/glob.c b/misc/glob.c
index 3bebe9e..921b8c0 100644
--- a/misc/glob.c
+++ b/misc/glob.c
@@ -944,6 +944,11 @@ __glob_pattern_p (const char *pattern, int quote)
 }
 # ifdef _LIBC
 weak_alias (__glob_pattern_p, glob_pattern_p)
+# else
+int glob_pattern_p (__const char *__pattern, int __quote)
+{
+    return __glob_pattern_p(__pattern, __quote);
+}
 # endif
 #endif
 
diff --git a/rpm2cpio.c b/rpm2cpio.c
index ed3051e..75b4f5d 100644
--- a/rpm2cpio.c
+++ b/rpm2cpio.c
@@ -20,7 +20,7 @@ int main(int argc, char *argv[])
     int rc;
     FD_t gzdi;
     
-    setprogname(argv[0]);	/* Retrofit glibc __progname */
+    xsetprogname(argv[0]);	/* Retrofit glibc __progname */
     rpmReadConfigFiles(NULL, NULL);
     if (argc == 1)
 	fdi = fdDup(STDIN_FILENO);
diff --git a/rpmio/rpmio.c b/rpmio/rpmio.c
index 2fbbf91..30f7685 100644
--- a/rpmio/rpmio.c
+++ b/rpmio/rpmio.c
@@ -1455,12 +1455,13 @@ int Fclose(FD_t fd)
 	
 	if (fps->io == fpio) {
 	    FILE *fp;
-	    int fpno;
+	    int fpno = -1;
 
 	    fp = fdGetFILE(fd);
-	    fpno = fileno(fp);
-	    if (fp)
+	    if (fp) {
+	        fpno = fileno(fp);
 	    	rc = fclose(fp);
+            }
 	    if (fpno == -1) {
 	    	fd = fdFree(fd);
 	    	fdPop(fd);
@@ -1758,7 +1759,8 @@ int Ferror(FD_t fd)
 	int ec;
 	
 	if (fps->io == fpio) {
-	    ec = ferror(fdGetFILE(fd));
+            FILE *fs = fdGetFILE(fd);
+	    ec = fs ? ferror(fs) : -1;
 	} else if (fps->io == gzdio) {
 	    ec = (fd->syserrno || fd->errcookie != NULL) ? -1 : 0;
 	    i--;	/* XXX fdio under gzdio always has fdno == -1 */
diff --git a/rpmqv.c b/rpmqv.c
index 989e95a..f69adf3 100644
--- a/rpmqv.c
+++ b/rpmqv.c
@@ -92,8 +92,8 @@ int main(int argc, char *argv[])
 
     /* Set the major mode based on argv[0] */
 #ifdef	IAM_RPMQV
-    if (rstreq(__progname, "rpmquery"))	bigMode = MODE_QUERY;
-    if (rstreq(__progname, "rpmverify")) bigMode = MODE_VERIFY;
+    if (rstreq(__progname ? __progname : "", "rpmquery"))	bigMode = MODE_QUERY;
+    if (rstreq(__progname ? __progname : "", "rpmverify")) bigMode = MODE_VERIFY;
 #endif
 
 #if defined(IAM_RPMQV)
diff --git a/system.h b/system.h
index 9b23e45..2f3378d 100644
--- a/system.h
+++ b/system.h
@@ -21,6 +21,7 @@
 #ifdef __APPLE__
 #include <crt_externs.h>
 #define environ (*_NSGetEnviron())
+#define fdatasync fsync
 #else
 extern char ** environ;
 #endif /* __APPLE__ */
@@ -113,10 +114,10 @@ typedef	char * security_context_t;
 #if __GLIBC_MINOR__ >= 1
 #define	__progname	__assert_program_name
 #endif
-#define	setprogname(pn)
+#define	xsetprogname(pn) setprogname((pn))
 #else
 #define	__progname	program_name
-#define	setprogname(pn)	\
+#define	xsetprogname(pn)	\
   { if ((__progname = strrchr(pn, '/')) != NULL) __progname++; \
     else __progname = pn;		\
   }
