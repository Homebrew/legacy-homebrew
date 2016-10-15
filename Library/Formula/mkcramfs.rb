class Mkcramfs < Formula
  homepage "http://cramfs.sourceforge.net/"
  url "https://downloads.sourceforge.net/sourceforge/cramfs/cramfs-1.1.tar.gz"
  sha1 "08133f2a2a0f02c6dd07c8dc565a4eac6bc967cd"

  # mkcramfs uses loff_t and MAP_ANONYMOUS, which are not defined on OS X
  patch :DATA

  def install
    system "make", "mkcramfs"
    bin.install "mkcramfs"
  end

  test do
    mkdir "test"
    touch "test/test.txt"
    system "#{bin}/mkcramfs", "test", "test.cram"
  end
end

__END__
diff -Naur a/mkcramfs.c b/mkcramfs.c
--- a/mkcramfs.c    2002-02-20 00:03:32.000000000 -0800
+++ b/mkcramfs.c    2014-11-03 10:22:06.000000000 -0800
@@ -36,6 +36,14 @@
 #include <linux/cramfs_fs.h>
 #include <zlib.h>
 
+#ifndef linux
+typedef long long loff_t;
+#endif
+
+#if !defined(MAP_ANONYMOUS) && defined(MAP_ANON)
+#define MAP_ANONYMOUS MAP_ANON
+#endif
+
 /* Exit codes used by mkfs-type programs */
 #define MKFS_OK          0 /* No errors */
 #define MKFS_ERROR       8 /* Operational error */
