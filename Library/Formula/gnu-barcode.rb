class GnuBarcode < Formula
  desc "Convert text strings to printed bars"
  homepage "https://www.gnu.org/software/barcode/"
  url "http://ftpmirror.gnu.org/barcode/barcode-0.99.tar.gz"
  mirror "https://ftp.gnu.org/gnu/barcode/barcode-0.99.tar.gz"
  sha256 "7c031cf3eb811242f53664379aebbdd9fae0b7b26b5e5d584c31a9f338154b64"

  # Patch and ac_cv_func_calloc_0_nonnull config addresses the following issue:
  # https://lists.gnu.org/archive/html/bug-barcode/2015-06/msg00001.html
  patch :DATA

  def install
    system "./configure", "ac_cv_func_calloc_0_nonnull=yes",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make"
    system "make", "MAN1DIR=#{man1}",
                   "MAN3DIR=#{man3}",
                   "INFODIR=#{info}",
                   "install"
  end

  test do
    (testpath/"test.txt").write("12345")
    system "#{bin}/barcode", "-e", "CODE39", "-i", "test.txt", "-o", "test.ps"
    assert File.read("test.ps").start_with?("")
  end
end

__END__
diff -bur barcode-original/barcode.h barcode-new/barcode.h
--- barcode-original/barcode.h  2013-03-29 16:51:07.000000000 -0500
+++ barcode-new/barcode.h       2015-08-16 16:06:23.000000000 -0500
@@ -123,6 +123,6 @@
 }
 #endif

-int streaming;
+extern int streaming;

 #endif /* _BARCODE_H_ */
diff -bur barcode-original/pcl.c barcode-new/pcl.c
--- barcode-original/pcl.c      2013-03-29 17:23:31.000000000 -0500
+++ barcode-new/pcl.c   2015-08-16 16:07:06.000000000 -0500
@@ -29,6 +29,7 @@

 #define SHRINK_AMOUNT 0.15  /* shrink the bars to account for ink spreading */

+int streaming;

 /*
  * How do the "partial" and "textinfo" strings work? See file "ps.c"
