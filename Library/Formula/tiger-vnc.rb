require 'formula'

class TigerVnc < Formula
  homepage 'http://tigervnc.org/'
  url 'http://downloads.sourceforge.net/project/tigervnc/tigervnc/1.2.0/tigervnc-1.2.0.tar.gz'
  sha1 '0542b2549a85b6723deebc3b5ecafa4f1fbee8e6'

  depends_on 'cmake' => :build
  depends_on 'gnutls' => :recommended
  depends_on 'jpeg-turbo'
  depends_on 'gettext'
  depends_on :x11

	# Fix build of included fltk library on Mountain Lion
	# http://www.fltk.org/str.php?L2864
  def patches
    { :p0 => DATA }
  end

  def install
    gettext = Formula.factory('gettext')
    turbo   = Formula.factory('jpeg-turbo')
    args = std_cmake_args + %W[
      -DJPEG_INCLUDE_DIR=#{turbo.include}
      -DJPEG_LIBRARY=#{turbo.lib}/libjpeg.dylib
      -DCMAKE_PREFIX_PATH=#{gettext.prefix}
      .
    ]
    system 'cmake', *args
    system 'make install'
    mv (prefix+'man'), share
  end
end

__END__
Index: common/fltk/src/filename_list.cxx
===================================================================
--- common/fltk/src/filename_list.cxx (revision 9648)
+++ common/fltksrc/filename_list.cxx (revision 9649)
@@ -22,7 +22,9 @@
 #include <FL/fl_utf8.h>
 #include "flstring.h"
 #include <stdlib.h>
-
+#ifdef __APPLE__
+#include <FL/x.H>
+#endif

 extern "C" {
 #ifndef HAVE_SCANDIR
@@ -95,7 +97,7 @@
 #ifndef HAVE_SCANDIR
   // This version is when we define our own scandir
   int n = fl_scandir(dirloc, list, 0, sort);
-#elif defined(HAVE_SCANDIR_POSIX) && !defined(__APPLE__)
+#elif defined(HAVE_SCANDIR_POSIX)
   // POSIX (2008) defines the comparison function like this:
   int n = scandir(dirloc, list, 0, (int(*)(const dirent **, const dirent **))sort);
 #elif defined(__osf__)
Index: common/fltk/FL/mac.H
===================================================================
--- common/fltk/FL/mac.H  (revision 9648)
+++ common/fltk/FL/mac.H  (revision 9649)
@@ -149,6 +149,21 @@
 #ifndef MAC_OS_X_VERSION_10_6
 #define MAC_OS_X_VERSION_10_6 1060
 #endif
+#ifndef MAC_OS_X_VERSION_10_7
+#define MAC_OS_X_VERSION_10_7 1070
+#endif
+#ifndef MAC_OS_X_VERSION_10_8
+#define MAC_OS_X_VERSION_10_8 1080
+#endif
+
+#if defined(FL_LIBRARY) || defined(FL_INTERNALS)
+#ifdef HAVE_SCANDIR_POSIX
+#undef HAVE_SCANDIR_POSIX
+#endif
+#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_8
+#define HAVE_SCANDIR_POSIX 1
+#endif
+#endif // FL_LIBRARY || FL_INTERNALS

 typedef CGImageRef Fl_Bitmask;
