require 'formula'

class Rpm < Formula
  homepage 'http://www.rpm.org/'
  url 'http://rpm.org/releases/rpm-4.10.x/rpm-4.10.1.tar.bz2'
  sha1 '3881f0f0fb686405517bfa367c49d36a0cc7a2c3'

  depends_on 'pkg-config' => :build
  depends_on 'lua'
  depends_on 'nss'
  depends_on 'nspr'
  depends_on 'libmagic'
  depends_on 'popt'
  depends_on 'berkeley-db'
  depends_on 'xz'

  # setprogname conflicts with setprogname(3), weak_alias not supported
  def patches
    DATA
  end

  def install
    ENV.append 'CPPFLAGS', "-I#{HOMEBREW_PREFIX}/include/nss -I#{HOMEBREW_PREFIX}/include/nspr"
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{HOMEBREW_PREFIX}/etc
      --localstatedir=#{HOMEBREW_PREFIX}/var
      --with-external-db
      --without-hackingdocs
      --enable-python
    ]
    system './configure', *args
    system "make"
    system "make install"
    # the default install makes /usr/bin/rpmquery a symlink to /bin/rpm
    # by using ../.. but that doesn't really work with any other prefix.
    ln_sf "rpm", "#{bin}/rpmquery"
    ln_sf "rpm", "#{bin}/rpmverify"
  end
end

__END__
diff --git a/lib/poptALL.c b/lib/poptALL.c
index d2db871..e02094b 100644
--- a/lib/poptALL.c
+++ b/lib/poptALL.c
@@ -234,7 +234,7 @@ rpmcliInit(int argc, char *const argv[], struct poptOption * optionsTable)
     int rc;
     const char *ctx, *execPath;
 
-    setprogname(argv[0]);       /* Retrofit glibc __progname */
+    xsetprogname(argv[0]);       /* Retrofit glibc __progname */
 
     /* XXX glibc churn sanity */
     if (__progname == NULL) {
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
index 89ebdfa..f35c7c8 100644
--- a/rpm2cpio.c
+++ b/rpm2cpio.c
@@ -21,7 +21,7 @@ int main(int argc, char *argv[])
     off_t payload_size;
     FD_t gzdi;
     
-    setprogname(argv[0]);	/* Retrofit glibc __progname */
+    xsetprogname(argv[0]);	/* Retrofit glibc __progname */
     rpmReadConfigFiles(NULL, NULL);
     if (argc == 1)
 	fdi = fdDup(STDIN_FILENO);
diff --git a/rpmqv.c b/rpmqv.c
index da5f2ca..d033d21 100644
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
index dd35738..78dec9f 100644
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
@@ -114,10 +115,10 @@ typedef	char * security_context_t;
 #if __GLIBC_MINOR__ >= 1
 #define	__progname	__assert_program_name
 #endif
-#define	setprogname(pn)
+#define	xsetprogname(pn)
 #else
 #define	__progname	program_name
-#define	setprogname(pn)	\
+#define	xsetprogname(pn)	\
   { if ((__progname = strrchr(pn, '/')) != NULL) __progname++; \
     else __progname = pn;		\
   }
