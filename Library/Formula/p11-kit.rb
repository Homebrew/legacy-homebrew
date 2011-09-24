require 'formula'

class P11Kit < Formula
  url 'http://p11-glue.freedesktop.org/releases/p11-kit-0.6.tar.gz'
  homepage 'http://p11-glue.freedesktop.org'
  md5 'c1ff3e52f172fda8bf3b426f7fb63c92'

  def patches
    # Patch to get PATH_MAX; fixed upstream:
    # http://cgit.freedesktop.org/p11-glue/p11-kit/commit/?id=8054865
    DATA
  end

  def install
    ENV.universal_binary
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make check"
    system "make install"
  end
end

__END__
diff --git a/p11-kit/modules.c b/p11-kit/modules.c
index 3f1eae1..4c87cee 100644
--- a/p11-kit/modules.c
+++ b/p11-kit/modules.c
@@ -50,11 +50,12 @@
 #include <dirent.h>
 #include <dlfcn.h>
 #include <errno.h>
+#include <limits.h>
 #include <pthread.h>
 #include <stdarg.h>
 #include <stddef.h>
-#include <stdlib.h>
 #include <stdio.h>
+#include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
