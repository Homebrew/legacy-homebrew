require 'formula'

class SystemC < Formula
  url 'http://www-verimag.imag.fr/~moy/systemc-2.2.0.tgz'
  homepage 'http://www.systemc.org'
  md5 'ccd0a9b8987b2902de647cfd0794e668'

  def options
    [
      ['--32bit', 'install the 32-bit version.']
    ]
  end

  def install
    arch_string = (Hardware.is_64_bit? and not ARGV.include? '--32bit') ? "x86_64-apple-macosx" : "i386-apple-macosx"
    system "aclocal"
    system "autoconf"
    system "automake"
    system "./configure", "--prefix=#{prefix}", "--build=#{arch_string}", "--host=#{arch_string}"
    system "make"
    ENV.j1
    system "make install"
  end

  def patches
    # 3 patches
    # one fixes a missing configure case that prohibits building under OS X
    # the other two fix a bug in make install of the examples (which are not installed in the cellar anyway)
    # by making automake not build the examples
    # the examples ran fine with me using 'make check'
    DATA
  end

end

__END__
diff --git a/src/sysc/utils/Makefile.am b/src/sysc/utils/Makefile.am
index d6539d4..27d3cd1 100644
--- a/src/sysc/utils/Makefile.am
+++ b/src/sysc/utils/Makefile.am
@@ -70,7 +70,7 @@ libutils_a_SOURCES = $(H_FILES) $(CXX_FILES)
 
 INCLUDE_DIR = $(prefix)/include/sysc/utils
 
-CXXCOMPILE_DEBUG = $(CXX) $(DEFS) $(INCLUDES) $(AM_CPPFLAGS) $(CPPFLAGS) $(AM_CXXFLAGS) $(EXTRA_CXXFLAGS) $(DEBUG_CXXFLAGS)
+CXXCOMPILE_DEBUG = $(CXX) $(DEFS) $(INCLUDES) $(AM_CPPFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(AM_CXXFLAGS) $(EXTRA_CXXFLAGS) $(DEBUG_CXXFLAGS)
 
 sc_stop_here.o: sc_stop_here.cpp
        $(CXXCOMPILE_DEBUG) -c $<
diff --git a/configure.in b/configure.in
index 7231a7a..3616660 100644
--- a/configure.in
+++ b/configure.in
@@ -128,6 +128,43 @@ echo "$as_me: error: \"sorry...compiler not supported\"" >&2;}
 	AS=as
         QT_ARCH="x86_64"
         ;;
+    x86_64*macosx*)
+        case "$CXX_COMP" in
+            c++ | g++* | gcc-* | llvm*)
+                EXTRA_CXXFLAGS="-Wall"
+                DEBUG_CXXFLAGS="-g"
+                OPT_CXXFLAGS="-O3"
+                TARGET_ARCH="macosx"
+                CC="$CXX"
+                CFLAGS="$EXTRA_CXXFLAGS $OPT_CXXFLAGS"
+                CXXFLAGS="$EXTRA_CXXFLAGS $OPT_CXXFLAGS"
+                ;;
+            *)
+                AC_MSG_ERROR("sorry...compiler not supported")
+               ;;
+        esac
+        AS=as
+        QT_ARCH="x86_64"
+        ;;
+    i386*macosx*)
+        case "$CXX_COMP" in
+            c++ | g++* | gcc-* | llvm*)
+                EXTRA_CXXFLAGS="-Wall"
+                DEBUG_CXXFLAGS="-g"
+                OPT_CXXFLAGS="-O3 -m32 -arch i386"
+                TARGET_ARCH="macosx"
+                CC="$CXX"
+                CFLAGS="$EXTRA_CXXFLAGS $OPT_CXXFLAGS"
+                CXXFLAGS="$EXTRA_CXXFLAGS $OPT_CXXFLAGS"
+                LDFLAGS="-m32 -arch i386"
+                ;;
+            *)
+                AC_MSG_ERROR("sorry...compiler not supported")
+               ;;
+        esac
+        AS="as -arch i386"
+        QT_ARCH="iX86-ss"
+        ;;
     *linux*)
         case "$CXX_COMP" in
             c++ | g++)
diff --git a/Makefile.am b/Makefile.am
index 1e99a7c..f9aa934 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -31,7 +31,6 @@
 ## ****************************************************************************
 
 SUBDIRS = \
 	src \
-	examples \
 	.
 
diff --git a/src/sysc/kernel/sc_cor.h b/src/sysc/kernel/sc_cor.h
index 75434f7..e76b4fa 100644
--- a/src/sysc/kernel/sc_cor.h
+++ b/src/sysc/kernel/sc_cor.h
@@ -44,6 +44,10 @@
 #ifndef SC_COR_H
 #define SC_COR_H
 
+#if defined(__BEOS__) || defined(__NetBSD__) || defined(__APPLE__)
+#include <inttypes.h>
+#include <sys/types.h>
+#endif
 
 #include <cassert>
 #include <cstdlib>
diff --git a/Makefile.in b/Makefile.in
index c269380..d54b5b7 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -92,7 +92,6 @@ install_sh = @install_sh@
 
 SUBDIRS = \
 	src \
-	examples \
 	.
