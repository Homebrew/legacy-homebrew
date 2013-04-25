require 'formula'

class P11Kit < Formula
  homepage 'http://p11-glue.freedesktop.org'
  url 'http://p11-glue.freedesktop.org/releases/p11-kit-0.18.1.tar.gz'
  sha256 '6e87e72b7768288384de2ca1929b3cb45502e9e944fc075a8ce5df8f08f1ab29'

  option :universal

  depends_on 'pkg-config' => :build
  depends_on 'libtasn1'

  def patches; DATA; end

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-trust-paths"
    system "make"
    system "make check"
    system "make install"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index b3c7610..6614ae5 100644
--- a/configure.ac
+++ b/configure.ac
@@ -398,7 +398,17 @@ echo $PACKAGE_VERSION | tr '.' ' ' | while read major minor unused; do
	break
 done
 
-eval SHLEXT=$shrext_cmds
+case "$host" in
+*-*-darwin*)
+	# It seems like libtool lies about this see:
+	# https://bugs.freedesktop.org/show_bug.cgi?id=57714
+	SHLEXT='.so'
+	;;
+*)
+	eval SHLEXT=$shrext_cmds
+	;;
+esac
+
 AC_DEFINE_UNQUOTED(SHLEXT, ["$SHLEXT"], [File extension for shared libraries])
 AC_SUBST(SHLEXT)
 
--- a/configure
+++ b/configure
@@ -17315,7 +17201,17 @@
        break
 done

-eval SHLEXT=$shrext_cmds
+case "$host" in
+*-*-darwin*)
+       # It seems like libtool lies about this see:
+       # https://bugs.freedesktop.org/show_bug.cgi?id=57714
+       SHLEXT='.so'
+       ;;
+*)
+       eval SHLEXT=$shrext_cmds
+       ;;
+esac
+

 cat >>confdefs.h <<_ACEOF
 #define SHLEXT "$SHLEXT"
--- p11-kit-0.18.1/common/library.c	2013-04-03 08:30:32.000000000 -0700
+++ p11-kit-0.18.1.new/common/library.c	2013-04-23 17:54:08.000000000 -0700
@@ -60,7 +60,7 @@
 p11_mutex_t p11_library_mutex;
 
 #ifdef OS_UNIX
-pthread_once_t p11_library_once;
+pthread_once_t p11_library_once = PTHREAD_ONCE_INIT;
 #endif
 
 static char *
