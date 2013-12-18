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
  # Patch for compatibility with gnutls 3
  # Fix black screen issue on Mountain Lion
  # http://permalink.gmane.org/gmane.network.vnc.tigervnc.user/544
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

Index: common/rdr/TLSInStream.cxx
===================================================================
--- /dev/null
+++ common/rdr/TLSInStream.cxx
@@ -27,9 +27,7 @@
 #include <rdr/TLSInStream.h>
 #include <errno.h>

-#ifdef HAVE_OLD_GNUTLS
 #define gnutls_transport_set_global_errno(A) do { errno = (A); } while(0)
-#endif

 #ifdef HAVE_GNUTLS
 using namespace rdr;
Index: common/rdr/TLSOutStream.cxx
===================================================================
--- /dev/null
+++ common/rdr/TLSOutStream.cxx
@@ -27,9 +27,7 @@
 #include <rdr/TLSOutStream.h>
 #include <errno.h>

-#ifdef HAVE_OLD_GNUTLS
 #define gnutls_transport_set_global_errno(A) do { errno = (A); } while(0)
-#endif

 #ifdef HAVE_GNUTLS
 using namespace rdr;
===================================================================
--- vncviewer/OSXPixelBuffer.h 2011/06/17 07:35:56     4504
+++ vncviewer/OSXPixelBuffer.h 2012/08/17 13:37:42     4956
@@ -29,8 +29,8 @@
   void draw(int src_x, int src_y, int x, int y, int w, int h);

 protected:
-  // This is really a CGImageRerf, but Apple headers conflict with FLTK
-  void *image;
+  // This is really a CGContextRef, but Apple headers conflict with FLTK
+  void *bitmap;
 };

===================================================================
--- vncviewer/OSXPixelBuffer.cxx       2011/08/23 12:04:46     4646
+++ vncviewer/OSXPixelBuffer.cxx       2012/08/17 13:37:42     4956
@@ -40,29 +40,24 @@
   ManagedPixelBuffer(rfb::PixelFormat(32, 24, false, true,
                                       255, 255, 255, 16, 8, 0),
                      width, height),
-  image(NULL)
+  bitmap(NULL)
 {
   CGColorSpaceRef lut;
-  CGDataProviderRef provider;

   lut = CGColorSpaceCreateDeviceRGB();
   assert(lut);
-  provider = CGDataProviderCreateWithData(NULL, data, datasize, NULL);
-  assert(provider);

-  image = CGImageCreate(width, height, 8, 32, width*4, lut,
-                        kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little,
-                        provider, NULL, false, kCGRenderingIntentDefault);
-  assert(image);
+  bitmap = CGBitmapContextCreate(data, width, height, 8, width*4, lut,
+                                 kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little);
+  assert(bitmap);

-  CGDataProviderRelease(provider);
   CGColorSpaceRelease(lut);
 }


 PlatformPixelBuffer::~PlatformPixelBuffer()
 {
-  CGImageRelease((CGImageRef)image);
+  CFRelease((CGContextRef)bitmap);
 }


@@ -71,6 +66,7 @@
   CGRect rect;
   CGContextRef gc;
   CGAffineTransform at;
+  CGImageRef image;

   gc = (CGContextRef)fl_gc;

@@ -102,7 +98,9 @@
   rect.size.width = width();
   rect.size.height = -height(); // Negative height does _not_ flip the image

-  CGContextDrawImage(gc, rect, (CGImageRef)image);
+  image = CGBitmapContextCreateImage((CGContextRef)bitmap);
+  CGContextDrawImage(gc, rect, image);
+  CGImageRelease(image);

   CGContextRestoreGState(gc);
 }
