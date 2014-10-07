require 'formula'

class Devil < Formula
  homepage 'http://sourceforge.net/projects/openil/'
  url 'https://downloads.sourceforge.net/project/openil/DevIL/1.7.8/DevIL-1.7.8.tar.gz'
  sha1 'bc27e3e830ba666a3af03548789700d10561fcb1'
  revision 1

  depends_on 'autoconf' => :build
  depends_on 'libpng'
  depends_on 'jpeg'

  option :universal

  # fix compilation issue for iluc.c
  patch :DATA

  def install
    ENV.universal_binary if build.universal?

    system "autoconf"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-ILU",
                          "--enable-ILUT"
    system "make install"
  end
end

__END__
commit ac7d7836fde98b43f79e3510aaceabe5aa2dfb2e
Author: João Abecasis <joao@abecasis.name>
Date:   Wed Aug 27 08:48:53 2014 +0200

    Update to newer libpng
    
    From http://www.libpng.org/pub/png/libpng-manual.txt:
    
      X.  Changes to Libpng from version 1.0.x/1.2.x to 1.4.x
    
      [...]
    
      The function png_set_gray_1_2_4_to_8() was removed. It has been
      deprecated since libpng-1.0.18 and 1.2.9, when it was replaced with
      png_set_expand_gray_1_2_4_to_8() because the former function also
      expanded any tRNS chunk to an alpha channel.

diff --git a/src-IL/src/il_icon.c b/src-IL/src/il_icon.c
index 2ccb1a3..fd9475d 100644
--- a/src-IL/src/il_icon.c
+++ b/src-IL/src/il_icon.c
@@ -525,7 +525,7 @@ ILboolean ico_readpng_get_image(ICOIMAGE *Icon, ILdouble display_exponent)
 
 	// Expand low-bit-depth grayscale images to 8 bits
 	if (ico_color_type == PNG_COLOR_TYPE_GRAY && bit_depth < 8) {
-		png_set_gray_1_2_4_to_8(ico_png_ptr);
+		png_set_expand_gray_1_2_4_to_8(ico_png_ptr);
 	}
 
 	// Expand RGB images with transparency to full alpha channels
diff --git a/src-IL/src/il_png.c b/src-IL/src/il_png.c
index d5b627e..d5fe363 100644
--- a/src-IL/src/il_png.c
+++ b/src-IL/src/il_png.c
@@ -278,7 +278,7 @@ ILboolean readpng_get_image(ILdouble display_exponent)
 
 	// Expand low-bit-depth grayscale images to 8 bits
 	if (png_color_type == PNG_COLOR_TYPE_GRAY && bit_depth < 8) {
-		png_set_gray_1_2_4_to_8(png_ptr);
+		png_set_expand_gray_1_2_4_to_8(png_ptr);
 	}
 
 	// Expand RGB images with transparency to full alpha channels

commit 27aec49858f579f80c54565939f084afceea8246
Author: João Abecasis <joao@abecasis.name>
Date:   Tue Aug 26 15:46:08 2014 +0200

    Fix include for malloc

diff --git a/src-ILU/ilur/ilur.c b/src-ILU/ilur/ilur.c
index cc8424a..c07f4e8 100644
--- a/src-ILU/ilur/ilur.c
+++ b/src-ILU/ilur/ilur.c
@@ -1,6 +1,6 @@
 #include <string.h>
 #include <stdio.h>
-#include <malloc.h>
+#include <stdlib.h>
 
 #include <IL/il.h>
 #include <IL/ilu.h>

commit ccf12e35a948deb975ae71b875676ab4de455fb5
Author: João Abecasis <joao@abecasis.name>
Date:   Tue Aug 26 15:42:25 2014 +0200

    Fix endianness detection

diff --git a/src-IL/include/il_endian.h b/src-IL/include/il_endian.h
index 0818948..e3fb4a9 100644
--- a/src-IL/include/il_endian.h
+++ b/src-IL/include/il_endian.h
@@ -15,15 +15,16 @@
 
 #include "il_internal.h"
 
-#ifdef WORDS_BIGENDIAN  // This is defined by ./configure.
+#if defined(WORDS_BIGENDIAN) /* Defined by ./configure. */ \
+  || (defined(__BYTE_ORDER__) && __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__) \
+  || (defined(__BIG_ENDIAN__) && __BIG_ENDIAN__)
+
 	#ifndef __BIG_ENDIAN__
 	#define __BIG_ENDIAN__ 1
 	#endif
-#endif
 
-#if (defined(__BYTE_ORDER__) && __BYTE_ORDER__ == __BIG_ENDIAN__) \
-  || (defined(__BIG_ENDIAN__) && !defined(__LITTLE_ENDIAN__))
- 	#undef __LITTLE_ENDIAN__
+	#undef __LITTLE_ENDIAN__
+
 	#define Short(s) iSwapShort(s)
 	#define UShort(s) iSwapUShort(s)
 	#define Int(i) iSwapInt(i)
@@ -38,9 +39,12 @@
 	#define BigFloat(f)  
 	#define BigDouble(d)  
 #else
+	#ifndef __LITTLE_ENDIAN__
+	#define __LITTLE_ENDIAN__ 1
+	#endif
+
 	#undef __BIG_ENDIAN__
-	#undef __LITTLE_ENDIAN__  // Not sure if it's defined by any compiler...
-	#define __LITTLE_ENDIAN__
+
 	#define Short(s)  
 	#define UShort(s)  
 	#define Int(i)  
diff --git a/src-IL/src/il_psd.c b/src-IL/src/il_psd.c
index 257584c..6e330e1 100644
--- a/src-IL/src/il_psd.c
+++ b/src-IL/src/il_psd.c
@@ -698,7 +698,7 @@ ILboolean PsdGetData(PSDHEAD *Head, void *Buffer, ILboolean Compressed)
 				iCurImage->Bps /= 2;
 				for (y = 0; y < Head->Height * iCurImage->Bps; y += iCurImage->Bps) {
 					for (x = 0; x < iCurImage->Bps; x += iCurImage->Bpp, i++) {
-					 #ifndef WORDS_BIGENDIAN
+					 #ifndef __BIG_ENDIAN__
 						iSwapUShort(ShortPtr+i);
 					 #endif
 						((ILushort*)iCurImage->Data)[y + x + c] = ShortPtr[i];

commit 99a8bee0bde184b82f24c0df97e5fcb4bd1c7d01
Author: João Abecasis <joao@abecasis.name>
Date:   Tue Aug 26 15:07:48 2014 +0200

    Clang doesn't recognize restrict keyword in C++ mode

diff --git a/include/IL/il.h b/include/IL/il.h
index 540a56e..b3fc646 100644
--- a/include/IL/il.h
+++ b/include/IL/il.h
@@ -64,6 +64,9 @@
 #endif
 
 #ifdef RESTRICT_KEYWORD
+#if defined(__cplusplus) && defined(__clang__)
+#define restrict __restrict
+#endif
 #define RESTRICT restrict
 #define CONST_RESTRICT const restrict
 #else

commit 17dc0d701ed97b87a153db7134d4817b03d9dedb
Author: João Abecasis <joao@abecasis.name>
Date:   Tue Aug 26 15:01:59 2014 +0200

    Don't specify C99 standard when compiling C++

diff --git a/configure.ac b/configure.ac
index 8691708..3f503a7 100644
--- a/configure.ac
+++ b/configure.ac
@@ -216,7 +216,7 @@ AC_ARG_ENABLE([warning],
 	      [build_warning="no"])
 
 AS_IF([test "$build_warning" = "yes"],
-      [ADD_CFLAGS([-Wall -Werror])],
+      [ADD_GENERAL_CFLAGS([-Wall -Werror])],
       [])
 
 dnl
@@ -418,7 +418,7 @@ AS_CASE([$host],
         [*mingw32*],
         [PLATFORM="MINGW32"],
         [*cygwin*],
-        [ADD_CFLAGS([-mno-cygwin])
+        [ADD_GENERAL_CFLAGS([-mno-cygwin])
 	 LIBILUT_WIN32LIBPATH="-L/usr/lib/w32api"
 	 PLATFORM="CYGWIN"],
         [*darwin*],
diff --git a/m4/devil-definitions.m4 b/m4/devil-definitions.m4
index 7616e82..8af9c4d 100644
--- a/m4/devil-definitions.m4
+++ b/m4/devil-definitions.m4
@@ -1,5 +1,8 @@
 
 AC_DEFUN([ADD_CFLAGS],
+         [CFLAGS="$CFLAGS $1"])
+
+AC_DEFUN([ADD_GENERAL_CFLAGS],
 	 [GENERAL_CFLAGS="$GENERAL_CFLAGS $1"])
 dnl          IL_CFLAGS="$IL_CFLAGS $1"])
 dnl          ILU_CFLAGS="$ILU_CFLAGS $1"
@@ -25,7 +28,7 @@ AC_DEFUN([TEST_EXT],
                 AC_DEFINE([VECTORMEM],
                           [1],
                           [Memory must be vector aligned])
-                ADD_CFLAGS([$2])
+                ADD_GENERAL_CFLAGS([$2])
                 AC_MSG_RESULT([yes])
                 SUPPORTED_EXTENSION=$SUPPORTED_EXTENSION"$1 "],
                [test "$use_$1" = "test" -a "x$enable_asm" = "xyes"],
@@ -40,7 +43,7 @@ AC_DEFUN([TEST_EXT],
                                    AC_DEFINE([VECTORMEM],
                                              [],
                                              [Memory must be vector aligned])
-                                   ADD_CFLAGS([$2])
+                                   ADD_GENERAL_CFLAGS([$2])
                                    AC_MSG_RESULT([yes])
                                    SUPPORTED_EXTENSION=$SUPPORTED_EXTENSION"$1 "],
                                   [AC_MSG_RESULT([no]) ])
