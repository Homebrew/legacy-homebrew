require 'formula'

class Pngnq < Formula
  url 'http://downloads.sourceforge.net/project/pngnq/pngnq/1.1/pngnq-1.1.tar.gz'
  homepage 'http://pngnq.sourceforge.net/'
  md5 'fdbb94d504931b50c54202b62f98aa44'

  depends_on 'pkg-config' => :build
  depends_on :libpng

  # Fixes compilation on OSX Lion
  # png.h on Lion does not, in fact, include zlib.h
  # See: http://sourceforge.net/tracker/?func=detail&aid=3353513&group_id=213072&atid=1024252
  # See: http://sourceforge.net/tracker/?func=detail&aid=3402960&group_id=213072&atid=1024252
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
