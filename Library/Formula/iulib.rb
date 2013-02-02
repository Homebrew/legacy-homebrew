require 'formula'

class Iulib < Formula
  homepage 'http://code.google.com/p/iulib/'
  url 'http://iulib.googlecode.com/files/iulib-0.4.tgz'
  sha1 '96a006f806a650886fdd59b1239f6e56d1a864c1'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on :libpng
  depends_on "jpeg"
  depends_on "libtiff"

  def patches
    # fixes errors in header calls
    DATA
  end

  def install
    system "aclocal"
    system "./build", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

__END__
diff --git a/imglib/iulib.h b/imglib/iulib.h
index bc0eb34..06762c5 100644
--- a/../iulib-0.41/imglib/iulib.h
+++ b/imglib/iulib.h
@@ -27,10 +27,10 @@
 #ifndef iulib_h__
 #define iulib_h__
 #include "colib/colib.h"
-#include "bithacks.h"
-#include "imgbitptr.h"
-#include "imgbits.h"
-#include "imgrle.h"
+#include "imgbits/bithacks.h"
+#include "imgbits/imgbitptr.h"
+#include "imgbits/imgbits.h"
+#include "imgbits/imgrle.h"
 #include "autoinvert.h"
 #include "imgio.h"
 #include "io_jpeg.h"
@@ -50,6 +50,6 @@
 #include "imgrescale.h"
 #include "imgthin.h"
 #include "imgtrace.h"
-#include "dgraphics.h"
-#include "vidio.h"
+#include "utils/dgraphics.h"
+#include "vidio/vidio.h"
 #endif
