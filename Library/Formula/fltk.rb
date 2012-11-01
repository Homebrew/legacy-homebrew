require 'formula'

class Fltk < Formula
  homepage 'http://www.fltk.org/'
  url 'http://ftp.easysw.com/pub/fltk/1.3.0/fltk-1.3.0-source.tar.gz'
  sha1 '720f2804be6132ebae9909d4e74dedcc00b39d25'

  devel do
    url 'http://ftp.easysw.com/pub/fltk/snapshots/fltk-1.3.x-r9705.tar.bz2'
    version '1.3.x-r9705'
    sha1 '509cfae7fcb671a480339fa41545256e8f40c60c'
  end

  option 'examples', 'Build the examples and install them into share'

  depends_on 'cmake' => :build
  depends_on :libpng
  depends_on :freetype
  depends_on :fontconfig
  depends_on 'jpeg'

  fails_with :clang do
    build 318
    cause "http://llvm.org/bugs/show_bug.cgi?id=10338"
  end

  # Fix Mountain Lion build.
  # http://www.fltk.org/str.php?L2864
  # Committed upstream as r9649
  def patches
    { :p0 => DATA }
  end if build.stable?

  def install
    args = std_cmake_args + %W[
      -DOPTION_PREFIX_MAN=#{man}
      -DOPTION_PREFIX_CONFIG=#{share}/cmake/Modules
    ]
    args << '-DOPTION_BUILD_EXAMPLES=OFF' unless build.include? 'examples'
    args << '..'

    mkdir 'build' do
      system 'cmake', *args
      system 'make install'
    end
  end
end

__END__
Index: src/filename_list.cxx
===================================================================
--- src/filename_list.cxx	(revision 9648)
+++ src/filename_list.cxx	(revision 9649)
@@ -31,7 +31,9 @@
 #include <FL/fl_utf8.h>
 #include "flstring.h"
 #include <stdlib.h>
-
+#ifdef __APPLE__
+#include <FL/x.H>
+#endif

 extern "C" {
 #ifndef HAVE_SCANDIR
@@ -104,7 +104,7 @@
 #ifndef HAVE_SCANDIR
   // This version is when we define our own scandir
   int n = fl_scandir(dirloc, list, 0, sort);
-#elif defined(HAVE_SCANDIR_POSIX) && !defined(__APPLE__)
+#elif defined(HAVE_SCANDIR_POSIX)
   // POSIX (2008) defines the comparison function like this:
   int n = scandir(dirloc, list, 0, (int(*)(const dirent **, const dirent **))sort);
 #elif defined(__osf__)
Index: FL/mac.H
===================================================================
--- FL/mac.H	(revision 9648)
+++ FL/mac.H	(revision 9649)
@@ -52,6 +52,21 @@
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

 #if !(defined(FL_LIBRARY) || defined(FL_INTERNALS)) // this part is used when compiling an application program
