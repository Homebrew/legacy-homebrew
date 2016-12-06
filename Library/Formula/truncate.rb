class Truncate < Formula
  desc "truncates a file to a given size"
  homepage "http://www.vanheusden.com/truncate"
  url "http://www.vanheusden.com/truncate/truncate-0.8.tgz"
  sha256 "165914d643351324d69096427d3ce5d3ab13aed3f7c990a71ba3bd0c6f278f00"

  patch :DATA # remove missing file; rename syscalls for OSX which are natively 64bit

  def install
    system "make"
    bin.install "truncate"
    man1.install "truncate.1"
  end

  test do
    system "#{bin}/truncate", "-s", "1k", "testfile"
  end
end
__END__
diff --git a/truncate.c b/truncate.c
index 3dcb0d0..53cb190 100644
--- a/truncate.c
+++ b/truncate.c
@@ -9,7 +9,11 @@
 #include <sys/stat.h>
 #include <fcntl.h>
 
-#include "error.h"
+#ifdef __APPLE__
+#define off64_t off_t
+#define stat64 stat
+#define ftruncate64 ftruncate
+#endif
 
 off64_t get_file_size(char *file_name)
 {
