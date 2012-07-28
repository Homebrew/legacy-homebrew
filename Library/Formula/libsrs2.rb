require 'formula'

class Libsrs2 < Formula
  homepage 'http://www.libsrs2.org/'
  url 'http://www.libsrs2.org/srs/libsrs2-1.0.18.tar.gz'
  sha1 'db9452e5207bb573eca4b3409c201f1e0275d300'

  # Fix the miscomputation of the extension of the lib. The upstream version contains
  # an expression to compute the extension, but that expression contains spaces and
  # in some places the path of the target (containing the expression) get splitted
  # on spaces leading to an incomplete command to be run.
  def patches; DATA; end

  def install
    ENV.j1 # parallel build is not supported, not a big deal the lib is quite small

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff -u -Nrau libsrs2-1.0.18-orig/configure libsrs2-1.0.18/configure
--- libsrs2-1.0.18-orig/configure       2004-10-19 18:04:02.000000000 +0200
+++ libsrs2-1.0.18/configure    2012-07-28 15:29:15.000000000 +0200
@@ -8415,7 +8415,7 @@
   soname_spec='${libname}${release}${major}$shared_ext'
   shlibpath_overrides_runpath=yes
   shlibpath_var=DYLD_LIBRARY_PATH
-  shrext='$(test .$module = .yes && echo .so || echo .dylib)'
+  shrext='.dylib'
   # Apple's gcc prints 'gcc -print-search-dirs' doesn't operate the same.
   if test "$GCC" = yes; then
     sys_lib_search_path_spec=`$CC -print-search-dirs | tr "\n" "$PATH_SEPARATOR" | sed -e 's/libraries:/@libraries:/' | tr "@" "\n" | grep "^libraries:" | sed -e "s/^libraries://" -e "s,=/,/,g" -e "s,$PATH_SEPARATOR, ,g" -e "s,.*,& /lib /usr/lib /usr/local/lib,g"`
@@ -12168,7 +12168,7 @@
   soname_spec='${libname}${release}${major}$shared_ext'
   shlibpath_overrides_runpath=yes
   shlibpath_var=DYLD_LIBRARY_PATH
-  shrext='$(test .$module = .yes && echo .so || echo .dylib)'
+  shrext='.dylib'
   # Apple's gcc prints 'gcc -print-search-dirs' doesn't operate the same.
   if test "$GCC" = yes; then
     sys_lib_search_path_spec=`$CC -print-search-dirs | tr "\n" "$PATH_SEPARATOR" | sed -e 's/libraries:/@libraries:/' | tr "@" "\n" | grep "^libraries:" | sed -e "s/^libraries://" -e "s,=/,/,g" -e "s,$PATH_SEPARATOR, ,g" -e "s,.*,& /lib /usr/lib /usr/local/lib,g"`
@@ -15372,7 +15372,7 @@
   soname_spec='${libname}${release}${major}$shared_ext'
   shlibpath_overrides_runpath=yes
   shlibpath_var=DYLD_LIBRARY_PATH
-  shrext='$(test .$module = .yes && echo .so || echo .dylib)'
+  shrext='.dylib'
   # Apple's gcc prints 'gcc -print-search-dirs' doesn't operate the same.
   if test "$GCC" = yes; then
     sys_lib_search_path_spec=`$CC -print-search-dirs | tr "\n" "$PATH_SEPARATOR" | sed -e 's/libraries:/@libraries:/' | tr "@" "\n" | grep "^libraries:" | sed -e "s/^libraries://" -e "s,=/,/,g" -e "s,$PATH_SEPARATOR, ,g" -e "s,.*,& /lib /usr/lib /usr/local/lib,g"`
@@ -17774,7 +17774,7 @@
   soname_spec='${libname}${release}${major}$shared_ext'
   shlibpath_overrides_runpath=yes
   shlibpath_var=DYLD_LIBRARY_PATH
-  shrext='$(test .$module = .yes && echo .so || echo .dylib)'
+  shrext='.dylib'
   # Apple's gcc prints 'gcc -print-search-dirs' doesn't operate the same.
   if test "$GCC" = yes; then
     sys_lib_search_path_spec=`$CC -print-search-dirs | tr "\n" "$PATH_SEPARATOR" | sed -e 's/libraries:/@libraries:/' | tr "@" "\n" | grep "^libraries:" | sed -e "s/^libraries://" -e "s,=/,/,g" -e "s,$PATH_SEPARATOR, ,g" -e "s,.*,& /lib /usr/lib /usr/local/lib,g"`
