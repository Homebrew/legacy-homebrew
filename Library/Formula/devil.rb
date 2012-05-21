require 'formula'

class Devil < Formula
  url 'http://downloads.sourceforge.net/project/openil/DevIL/1.7.8/DevIL-1.7.8.tar.gz'
  homepage 'http://sourceforge.net/projects/openil/'
  md5 '7918f215524589435e5ec2e8736d5e1d'

  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'little-cms'
  depends_on 'jasper'
  depends_on 'pkg-config' => :build

  if MacOS.xcode_version.to_f >= 4.3
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  fails_with :clang do
    cause "Clang fails to compile C++ code with the flag -std=gnu99"
  end

  # fix compilation issue for iluc.c
  def patches; DATA; end

  def install
    system "autoreconf"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-ILU"
    system "make install"
  end
end

__END__
--- a/src-ILU/ilur/ilur.c   2009-03-08 08:10:12.000000000 +0100
+++ b/src-ILU/ilur/ilur.c  2010-09-26 20:01:45.000000000 +0200
@@ -1,6 +1,7 @@
 #include <string.h>
 #include <stdio.h>
-#include <malloc.h>
+#include <stdlib.h>
+#include "sys/malloc.h"

 #include <IL/il.h>
 #include <IL/ilu.h>

diff --git a/m4/devil-definitions.m4 b/m4/devil-definitions.m4
index 7616e82..9bc7f69 100644
--- a/m4/devil-definitions.m4
+++ b/m4/devil-definitions.m4
@@ -243,16 +243,15 @@ AC_DEFUN([SETTLE_MNG],
                                            [libmng]) ]) ]) 
 
 AC_DEFUN([SETTLE_PNG],
-         [DEVIL_IL_LIB([png.h],
-                       [png12]) 
-          AS_IF([test "x$have_png12" = "xno"],
-                [DEVIL_IL_LIB([png.h],
-                              [png]) 
-                 lib_test_result="$have_png"],
-                [lib_test_result="$have_png12"]) 
-          AS_IF([test "x$lib_test_result" = "xyes"],
-                [MAYBE_OPTIONAL_DEPENDENCY([IL],
-                                           [libpng]) ]) ]) 
+         [PKG_CHECK_MODULES([LIBPNG],
+                            [libpng],
+                            [have_png="yes"],
+                            [have_png="no"])
+          MAYBE_OPTIONAL_DEPENDENCY([IL],
+                                    [libpng])
+          IL_LIBS="$LIBPNG_LIBS $IL_LIBS"
+          IL_CFLAGS="$LIBPNG_CFLAGS $IL_CFLAGS"
+          lib_test_result="$have_png"])
 
 AC_DEFUN([SETTLE_TIFF],
          [DEVIL_IL_LIB([tiffio.h],

