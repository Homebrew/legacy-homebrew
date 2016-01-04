class Ttf2pt1 < Formula
  desc "True Type Font to Postscript Type 1 converter"
  homepage "http://ttf2pt1.sourceforge.net/"
  url "https://downloads.sourceforge.net/ttf2pt1/ttf2pt1-3.4.4.tgz"
  sha256 "ae926288be910073883b5c8a3b8fc168fde52b91199fdf13e92d72328945e1d0"

  patch :DATA

  depends_on "freetype" => :recommended

  def install

    args = %W[INSTDIR=#{prefix}]

    if build.with? "freetype"
      args << "CFLAGS_FT= -DUSE_FREETYPE -I#{Formula["freetype"].include}/freetype2 -I#{include}"
      args << "LIBS_FT=-L#{Formula["freetype"].lib} -lfreetype"
    end

    system "make", "all", *args
    bin.install "ttf2pt1"
    man1.install "ttf2pt1.1"
  end

end

# The patch is needed to update the FreeType headers from 1.x to 2.x.
# see http://www.freetype.org/freetype2/docs/tutorial/step1.html
__END__
--- /ft.c
+++ /ft.c
@@ -12,11 +12,12 @@
 #include <stdlib.h>
 #include <ctype.h>
 #include <sys/types.h>
-#include <freetype/freetype.h>
-#include <freetype/ftglyph.h>
-#include <freetype/ftsnames.h>
-#include <freetype/ttnameid.h>
-#include <freetype/ftoutln.h>
+#include <ft2build.h>
+#include FT_FREETYPE_H
+#include FT_GLYPH_H
+#include FT_SFNT_NAMES_H
+#include FT_TRUETYPE_IDS_H
+#include FT_OUTLINE_H
 #include "pt1.h"
 #include "global.h"
