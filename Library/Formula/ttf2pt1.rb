require 'formula'

class Ttf2pt1 < Formula
  url 'http://downloads.sourceforge.net/ttf2pt1/ttf2pt1-3.4.4.tgz'
  homepage 'http://ttf2pt1.sourceforge.net/'
  md5 'cb143c07cc83167875ca09ea720d4932'

  def patches
    # Enables freetype2 support patching ft.c and Makefile
    DATA
  end

  def install
    inreplace 'Makefile', /^INSTDIR.*$/, "INSTDIR = #{prefix}"
    system "make all"
    bin.install [ 'ttf2pt1' ]
    man1.install [ 'ttf2pt1.1' ]
  end
end

__END__
diff --git a/Makefile b/Makefile
index 2616d46..9dd13d1 100644
--- a/Makefile
+++ b/Makefile
@@ -9,7 +9,7 @@
 #
 # Use GNU C even if it's not the default compiler
 #
-#CC=gcc
+CC=gcc
 #
 # Use the standard ANSI C compiler on HP-UX even if it's not default
 #
@@ -54,24 +54,24 @@ LIBS_SYS= -lm
 # This WON'T BUILD with FT2-beta8, use the FreeType release 2.0.4
 # http://download.sourceforge.net/freetype/freetype-2.0.4.tar.gz
 
-CFLAGS_FT= 
+#CFLAGS_FT= 
 
 # To enable use of the FreeType-2 library
 # (if the include and lib directory do not match your installation,
 # modify them), also uncomment LIBS_FT
 #
-#CFLAGS_FT = -DUSE_FREETYPE -I/usr/local/include/freetype2 -I/usr/local/include
+CFLAGS_FT = -DUSE_FREETYPE -I/usr/X11/include/freetype2 -I/usr/X11/include
 
 # 
 # The FreeType-2 library flags (disabled by default)
 
-LIBS_FT=
+#LIBS_FT=
 
 # To enable use of the FreeType-2 library
 # (if the include and lib directory do not match your installation,
 # modify them), also uncomment CFLAGS_FT
 #
-#LIBS_FT= -L/usr/local/lib -lfreetype
+LIBS_FT= -L/usr/X11/lib -lfreetype
 
 #
 # The flags for C compiler for the Autotrace library (disabled by default). 
diff --git a/ft.c b/ft.c
index 4ca1ca6..cef79ea 100644
--- a/ft.c
+++ b/ft.c
@@ -12,6 +12,7 @@
 #include <stdlib.h>
 #include <ctype.h>
 #include <sys/types.h>
+#include <ft2build.h>
 #include <freetype/freetype.h>
 #include <freetype/ftglyph.h>
 #include <freetype/ftsnames.h>
 
