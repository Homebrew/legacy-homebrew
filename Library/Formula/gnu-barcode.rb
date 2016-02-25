class GnuBarcode < Formula
  desc "Convert text strings to printed bars"
  homepage "https://www.gnu.org/software/barcode/"
  url "http://ftpmirror.gnu.org/barcode/barcode-0.99.tar.gz"
  mirror "https://ftp.gnu.org/gnu/barcode/barcode-0.99.tar.gz"
  sha256 "7c031cf3eb811242f53664379aebbdd9fae0b7b26b5e5d584c31a9f338154b64"

  bottle do
    cellar :any_skip_relocation
    sha256 "1885abad5bc70c2e9952e131307ca7282d851856ebdea58dadc69f0e125a7c22" => :el_capitan
    sha256 "819af5d364f041397c7c6b768829df7fcbd617f86194a1656b5523eeaed9415a" => :yosemite
    sha256 "285a9fa2833e843765087545f778aeadc670555bcac38193788c866826a88d42" => :mavericks
    sha256 "344fb3bd8c8b078f79a76c7aa39e1986315bbd8e586ad16ddb54e285b73afa3c" => :mountain_lion
  end

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
