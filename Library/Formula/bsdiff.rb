require 'formula'

class Bsdiff <Formula
  url 'http://www.daemonology.net/bsdiff/bsdiff-4.3.tar.gz'
  homepage 'http://www.daemonology.net/bsdiff'
  md5 'e6d812394f0e0ecc8d5df255aa1db22a'

  def patches
    DATA
  end

  def install
    system "/usr/bin/bsdmake"
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
