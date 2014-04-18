require 'formula'

class Bsdiff < Formula
  homepage 'http://www.daemonology.net/bsdiff'
  url 'http://www.daemonology.net/bsdiff/bsdiff-4.3.tar.gz'
  sha1 '0c0a89d604fc55ef2b5e69cd18372b2972edd8b8'

  depends_on :bsdmake

  patch :DATA

  def install
    system "bsdmake"
    bin.install "bsdiff"
    man1.install "bsdiff.1"
  end
end

__END__
diff --git a/bspatch.c b/bspatch.c
index 643c60b..543379c 100644
--- a/bspatch.c
+++ b/bspatch.c
@@ -28,6 +28,7 @@
 __FBSDID("$FreeBSD: src/usr.bin/bsdiff/bspatch/bspatch.c,v 1.1 2005/08/06 01:59:06 cperciva Exp $");
 #endif
 
+#include <sys/types.h>
 #include <bzlib.h>
 #include <stdlib.h>
 #include <stdio.h>
