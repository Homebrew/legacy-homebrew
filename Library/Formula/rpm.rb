require 'formula'

class Rpm < Formula
  homepage 'http://www.rpm.org/'
  url 'http://rpm.org/releases/rpm-4.11.x/rpm-4.11.0.1.tar.bz2'
  sha1 '4f4362c40136c3a59ce164c142d62ea081793379'

  depends_on 'pkg-config' => :build
  depends_on 'nss'
  depends_on 'nspr'
  depends_on 'libmagic'
  depends_on 'popt'
  depends_on 'lua'
  depends_on 'berkeley-db'
  depends_on 'xz'

  # setprogname conflicts with setprogname(3)
  def patches
    DATA
  end

  def install
    # some of nss/nspr formulae might be keg-only:
    ENV.append 'CPPFLAGS', "-I#{Formula.factory('nss').include}/nss"
    ENV.append 'CPPFLAGS', "-I#{Formula.factory('nspr').include}/nspr"
    # pkg-config support was removed from lua 5.2:
    ENV['LUA_CFLAGS'] = "-I#{HOMEBREW_PREFIX}/include"
    ENV['LUA_LIBS'] = "-L#{HOMEBREW_PREFIX}/lib -llua"
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{HOMEBREW_PREFIX}/etc
      --localstatedir=#{HOMEBREW_PREFIX}/var
      --with-external-db
      --with-lua
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
index 541e8c4..5cecc2a 100644
--- a/lib/poptALL.c
+++ b/lib/poptALL.c
@@ -244,7 +244,7 @@ rpmcliInit(int argc, char *const argv[], struct poptOption * optionsTable)
     int rc;
     const char *ctx, *execPath;
 
-    setprogname(argv[0]);       /* Retrofit glibc __progname */
+    xsetprogname(argv[0]);       /* Retrofit glibc __progname */
 
     /* XXX glibc churn sanity */
     if (__progname == NULL) {
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
index f3b1bab..bf264f5 100644
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
@@ -116,10 +117,10 @@ typedef	char * security_context_t;
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
