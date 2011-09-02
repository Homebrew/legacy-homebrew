require 'formula'

class Pngnq < Formula
  url 'http://downloads.sourceforge.net/project/pngnq/pngnq/1.1/pngnq-1.1.tar.gz'
  homepage 'http://pngnq.sourceforge.net/'
  md5 'fdbb94d504931b50c54202b62f98aa44'

  depends_on 'pkg-config' => :build

  def install
    ENV.x11 # for libpng
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def patches
    # Fixes compilation on OSX Lion
    DATA
  end
end

__END__
diff --git a/src/rwpng.c b/src/rwpng.c
index aaa21fc..5324afe 100644
--- a/src/rwpng.c
+++ b/src/rwpng.c
@@ -31,6 +31,7 @@

 #include <stdio.h>
 #include <stdlib.h>
+#include <zlib.h>

 #include "png.h"        /* libpng header; includes zlib.h */
 #include "rwpng.h"      /* typedefs, common macros, public prototypes */
