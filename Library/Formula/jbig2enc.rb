require 'formula'

class Jbig2enc < Formula
  homepage 'https://github.com/agl/jbig2enc'
  revision 1

  stable do
    url 'https://github.com/agl/jbig2enc/archive/0.28-dist.tar.gz'
    sha1 'd2d73f732168eeb6fa18962dbe7743337363c3b6'
    version '0.28'

    # Patch data from https://github.com/agl/jbig2enc/commit/53ce5fe7e73d7ed95c9e12b52dd4984723f865fa
    patch :DATA
  end

  head do
    url 'https://github.com/agl/jbig2enc.git'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on 'leptonica'

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index fe37c22..753a607 100644
--- a/configure.ac
+++ b/configure.ac
@@ -55,6 +55,7 @@ AC_CHECK_LIB([lept], [findFileFormatStream], [], [
 			echo "Error! Leptonica not detected."
 			exit -1
 			])
+AC_CHECK_FUNCS(expandBinaryPower2Low,,)
 # test for function - it should detect leptonica dependecies
 
 # Check for possible dependancies of leptonica.
diff --git a/src/jbig2.cc b/src/jbig2.cc
index e10f042..515c1ef 100644
--- a/src/jbig2.cc
+++ b/src/jbig2.cc
@@ -130,11 +130,16 @@ segment_image(PIX *pixb, PIX *piximg) {
   // input color image, so we have to do it this way...
   // is there a better way?
   // PIX *pixd = pixExpandBinary(pixd4, 4);
-  PIX *pixd = pixCreate(piximg->w, piximg->h, 1);
-  pixCopyResolution(pixd, piximg);
-  if (verbose) pixInfo(pixd, "mask image: ");
-  expandBinaryPower2Low(pixd->data, pixd->w, pixd->h, pixd->wpl,
+  PIX *pixd;
+#ifdef HAVE_EXPANDBINARYPOWER2LOW
+    pixd = pixCreate(piximg->w, piximg->h, 1);
+    pixCopyResolution(pixd, piximg);
+    expandBinaryPower2Low(pixd->data, pixd->w, pixd->h, pixd->wpl,
                         pixd4->data, pixd4->w, pixd4->h, pixd4->wpl, 4);
+#else
+    pixd = pixExpandBinaryPower2(pixd4, 4);
+#endif
+  if (verbose) pixInfo(pixd, "mask image: ");
 
   pixDestroy(&pixd4);
   pixDestroy(&pixsf4);
