require 'formula'

class Iksemel < Formula
  homepage 'http://code.google.com/p/iksemel/'
  url 'http://iksemel.googlecode.com/files/iksemel-1.4.tar.gz'
  md5 '532e77181694f87ad5eb59435d11c1ca'

  depends_on 'gnutls'
  depends_on 'pkg-config' => :build
  
  def patches
    # Fix to use pkg-config to find gnutls vice the no longer existent libgnutls-config.
    # Next release fixes this.
    DATA
  end
  
  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/ikslint"
  end
end

__END__
diff --git a/configure b/configure
index bbf7ac6..e8077a6 100755
--- a/configure
+++ b/configure
@@ -1575,7 +1575,6 @@ Optional Packages:
   --with-pic              try to use only PIC/non-PIC objects [default=use
                           both]
   --with-tags[=TAGS]      include additional configurations [automatic]
-  --with-libgnutls-prefix=PFX   Prefix where libgnutls is installed (optional)
 
 Some influential environment variables:
   CC          C compiler command
@@ -21259,30 +21258,19 @@ done
 
 
 
-# Check whether --with-libgnutls-prefix was given.
-if test "${with_libgnutls_prefix+set}" = set; then
-  withval=$with_libgnutls_prefix; libgnutls_config_prefix="$withval"
-else
-  libgnutls_config_prefix=""
-fi
-
 
-  if test x$libgnutls_config_prefix != x ; then
-     if test x${LIBGNUTLS_CONFIG+set} != xset ; then
-        LIBGNUTLS_CONFIG=$libgnutls_config_prefix/bin/libgnutls-config
-     fi
-  fi
+PKG_CONFIG=pkg-config
 
   # Extract the first word of "libgnutls-config", so it can be a program name with args.
-set dummy libgnutls-config; ac_word=$2
+set dummy pkg-config; ac_word=$2
 { $as_echo "$as_me:$LINENO: checking for $ac_word" >&5
 $as_echo_n "checking for $ac_word... " >&6; }
-if test "${ac_cv_path_LIBGNUTLS_CONFIG+set}" = set; then
+if test "${ac_cv_path_PKG_CONFIG+set}" = set; then
   $as_echo_n "(cached) " >&6
 else
-  case $LIBGNUTLS_CONFIG in
+  case $PKG_CONFIG in
   [\\/]* | ?:[\\/]*)
-  ac_cv_path_LIBGNUTLS_CONFIG="$LIBGNUTLS_CONFIG" # Let the user override the test with a path.
+  ac_cv_path_PKG_CONFIG="$PKG_CONFIG" # Let the user override the test with a path.
   ;;
   *)
   as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
@@ -21292,7 +21280,7 @@ do
   test -z "$as_dir" && as_dir=.
   for ac_exec_ext in '' $ac_executable_extensions; do
   if { test -f "$as_dir/$ac_word$ac_exec_ext" && $as_test_x "$as_dir/$ac_word$ac_exec_ext"; }; then
-    ac_cv_path_LIBGNUTLS_CONFIG="$as_dir/$ac_word$ac_exec_ext"
+    ac_cv_path_PKG_CONFIG="$as_dir/$ac_word$ac_exec_ext"
     $as_echo "$as_me:$LINENO: found $as_dir/$ac_word$ac_exec_ext" >&5
     break 2
   fi
@@ -21300,14 +21288,14 @@ done
 done
 IFS=$as_save_IFS
 
-  test -z "$ac_cv_path_LIBGNUTLS_CONFIG" && ac_cv_path_LIBGNUTLS_CONFIG="no"
+  test -z "$ac_cv_path_PKG_CONFIG" && ac_cv_path_PKG_CONFIG="no"
   ;;
 esac
 fi
-LIBGNUTLS_CONFIG=$ac_cv_path_LIBGNUTLS_CONFIG
-if test -n "$LIBGNUTLS_CONFIG"; then
-  { $as_echo "$as_me:$LINENO: result: $LIBGNUTLS_CONFIG" >&5
-$as_echo "$LIBGNUTLS_CONFIG" >&6; }
+PKG_CONFIG=$ac_cv_path_PKG_CONFIG
+if test -n "$PKG_CONFIG"; then
+  { $as_echo "$as_me:$LINENO: result: $PKG_CONFIG" >&5
+$as_echo "$PKG_CONFIG" >&6; }
 else
   { $as_echo "$as_me:$LINENO: result: no" >&5
 $as_echo "no" >&6; }
@@ -21318,12 +21306,12 @@ fi
   { $as_echo "$as_me:$LINENO: checking for libgnutls - version >= $min_libgnutls_version" >&5
 $as_echo_n "checking for libgnutls - version >= $min_libgnutls_version... " >&6; }
   no_libgnutls=""
-  if test "$LIBGNUTLS_CONFIG" = "no" ; then
+  if test "$PKG_CONFIG" = "no" ; then
     no_libgnutls=yes
   else
-    LIBGNUTLS_CFLAGS=`$LIBGNUTLS_CONFIG $libgnutls_config_args --cflags`
-    LIBGNUTLS_LIBS=`$LIBGNUTLS_CONFIG $libgnutls_config_args --libs`
-    libgnutls_config_version=`$LIBGNUTLS_CONFIG $libgnutls_config_args --version`
+    LIBGNUTLS_CFLAGS=`$PKG_CONFIG $libgnutls_config_args --cflags gnutls`
+    LIBGNUTLS_LIBS=`$PKG_CONFIG $libgnutls_config_args --libs gnutls`
+    libgnutls_config_version=`$PKG_CONFIG $libgnutls_config_args --modversion gnutls`
 
 
       ac_save_CFLAGS="$CFLAGS"
