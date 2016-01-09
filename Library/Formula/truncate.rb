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
diff -Naur truncate-0.8/truncate.c truncate/truncate.c
--- truncate-0.8/truncate.c	2009-04-03 14:39:56 +0800
+++ truncate/truncate.c	2016-01-09 12:26:28 +0800
@@ -9,7 +9,15 @@
 #include <sys/stat.h>
 #include <fcntl.h>

-#include "error.h"
+//#include "error.h"
+void error_exit(char *format, ...);
+
+#ifdef __APPLE__
+#define off64_t off_t
+#define stat64 stat
+#define ftruncate64 ftruncate
+#define fstat64 fstat
+#endif

 off64_t get_file_size(char *file_name)
 {
