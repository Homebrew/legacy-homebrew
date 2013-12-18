require 'formula'

class Gbdfed < Formula
  homepage 'http://sofia.nmsu.edu/~mleisher/Software/gbdfed/'
  url 'http://sofia.nmsu.edu/~mleisher/Software/gbdfed/gbdfed-1.6.tar.gz'
  sha1 '733afccc43273d3385f8b9bc9d6334bcaa4403ae'

  depends_on 'pkg-config' => :build
  depends_on 'gtk+'

  # Fixes compilation error with gtk+ per note on the project homepage.
  def patches
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index b482958..10a528e 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -28,8 +28,7 @@ CC = @CC@
 CFLAGS = @XX_CFLAGS@ @CFLAGS@
 
 DEFINES = @DEFINES@ -DG_DISABLE_DEPRECATED \
-	-DGDK_DISABLE_DEPRECATED -DGDK_PIXBUF_DISABLE_DEPRECATED \
-	-DGTK_DISABLE_DEPRECATED
+	-DGDK_PIXBUF_DISABLE_DEPRECATED
 
 SRCS = bdf.c \
        bdfcons.c \
