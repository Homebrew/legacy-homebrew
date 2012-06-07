require 'formula'

class Leptonica < Formula
  homepage 'http://www.leptonica.org/'
  url 'http://www.leptonica.org/source/leptonica-1.68.tar.gz'
  md5 '5cd7092f9ff2ca7e3f3e73bfcd556403'

  depends_on :x11
  depends_on 'jpeg'
  depends_on 'libtiff'

  # Leptonica is missing an #include for PNG support
  # Can be removed in 1.69
  # http://code.google.com/p/leptonica/issues/detail?id=56
  def patches
    DATA
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff -Nurd -x'*~' leptonica-1.68.orig/src/pngio.c leptonica-1.68/src/pngio.c
--- leptonica-1.68.orig/src/pngio.c	2011-02-01 00:41:12.000000000 -0500
+++ leptonica-1.68/src/pngio.c	2011-07-09 09:17:17.000000000 -0400
@@ -108,6 +108,10 @@
 
 #include "png.h"
 
+#ifdef HAVE_LIBZ
+#include "zlib.h"
+#endif
+
 /* ----------------Set defaults for read/write options ----------------- */
     /* strip 16 bpp --> 8 bpp on reading png; default is for stripping */
 static l_int32   var_PNG_STRIP_16_TO_8 = 1;
