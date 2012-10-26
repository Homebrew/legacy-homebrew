require 'formula'

class Transfig < Formula
  url 'http://downloads.sourceforge.net/mcj/transfig.3.2.5d.tar.gz'
  version '3.2.5d'
  homepage 'http://www.xfig.org'
  sha1 '90ff277cc9b3fa0d0313052fcf5e3ffad8652abc'

  depends_on 'imake' => :build
  depends_on 'jpeg'
  depends_on 'ghostscript'
  depends_on :x11 => '2.7.2'

  def patches
    # transfig needs to be patched for libpng 1.5 (using patch from macports trunk@99018)
    DATA
  end

  def install
    # transfig does not like to execute makefiles in parallel
    ENV.deparallelize

    # patch file attributes of fig2dev/test.ps
    system "chmod u+rw fig2dev/test.ps"
    # patch file attributes of fig2dev/dev files
    system "chmod -R u+rw fig2dev/dev/*"

    # Patch tranfig/Imakefile
    inreplace "transfig/Imakefile", "XCOMM BINDIR = /usr/bin/X11",
              "BINDIR = #{bin}\n"+     # set install dir for bin
              "USRLIBDIR = #{lib}\n"  # set install dir for lib
    inreplace "transfig/Imakefile", "XCOMM MANDIR = $(MANSOURCEPATH)$(MANSUFFIX)",
              "MANDIR = #{man}$(MANSUFFIX)"
    inreplace "transfig/Imakefile", "XCOMM USELATEX2E = -DLATEX2E",
              "USELATEX2E = -DLATEX2E"

    # Patch fig2dev/Imakefile
    inreplace "fig2dev/Imakefile", "XCOMM BINDIR = /usr/bin/X11",
              "BINDIR = #{bin}\n"+     # set install dir for bin
              "USRLIBDIR = #{lib}\n"  # set install dir for lib
    inreplace "fig2dev/Imakefile", "XCOMM MANDIR = $(MANSOURCEPATH)$(MANSUFFIX)",
              "MANDIR = #{man}$(MANSUFFIX)"
    inreplace "fig2dev/Imakefile", "XFIGLIBDIR =	/usr/local/lib/X11/xfig",
              "XFIGLIBDIR = #{share}"
    inreplace "fig2dev/Imakefile","XCOMM USEINLINE = -DUSE_INLINE",
              "USEINLINE = -DUSE_INLINE"
    inreplace "fig2dev/Imakefile", "RGB = $(LIBDIR)/rgb.txt", "RGB = #{MacOS::X11.share}/X11/rgb.txt"
    inreplace "fig2dev/Imakefile", "PNGINC = -I/usr/include/X11","PNGINC = -I#{MacOS::X11.include}"
    inreplace "fig2dev/Imakefile", "PNGLIBDIR = $(USRLIBDIR)","PNGLIBDIR = #{MacOS::X11.lib}"
    inreplace "fig2dev/Imakefile", "ZLIBDIR = $(USRLIBDIR)", "ZLIBDIR = /usr/lib"
    inreplace "fig2dev/Imakefile", "XPMLIBDIR = $(USRLIBDIR)", "XPMLIBDIR = #{MacOS::X11.lib}"
    inreplace "fig2dev/Imakefile", "XPMINC = -I/usr/include/X11", "XPMINC = -I#{MacOS::X11.include}/X11"
    inreplace "fig2dev/Imakefile", "XCOMM DDA4 = -DA4", "DDA4 = -DA4"
    inreplace "fig2dev/Imakefile", "FIG2DEV_LIBDIR = /usr/local/lib/fig2dev",
              "FIG2DEV_LIBDIR = #{lib}/fig2dev"

    # generate Makefiles
    system "make clean"
    system "xmkmf"
    system "make Makefiles"

    # build everything
    system "make"

    # install everything
    system "make install"
    system "make install.man"
  end
end
__END__
diff --git a/fig2dev/dev/readpng.c b/fig2dev/dev/readpng.c
index d58657f..dbad3ac 100644
--- a/fig2dev/dev/readpng.c
+++ b/fig2dev/dev/readpng.c
@@ -62,7 +62,7 @@ read_png(file,filetype,pic,llx,lly)
     }
 
     /* set long jump here */
-    if (setjmp(png_ptr->jmpbuf)) {
+    if (setjmp(png_jmpbuf(png_ptr))) {
 	/* if we get here there was a problem reading the file */
 	png_destroy_read_struct(&png_ptr, &info_ptr, &end_info);
 	return 0;
@@ -78,15 +78,17 @@ read_png(file,filetype,pic,llx,lly)
     png_get_IHDR(png_ptr, info_ptr, &w, &h, &bit_depth, &color_type,
 	&interlace_type, &compression_type, &filter_type);
 
-    if (info_ptr->valid & PNG_INFO_gAMA)
-	png_set_gamma(png_ptr, 2.2, info_ptr->gamma);
-    else
-	png_set_gamma(png_ptr, 2.2, 0.45);
+    png_fixed_point gamma = 0.45;
+    png_get_gAMA_fixed(png_ptr,info_ptr,&gamma);
+    png_set_gamma(png_ptr, 2.2, gamma);
 
-    if (info_ptr->valid & PNG_INFO_bKGD)
+    if (png_get_valid(png_ptr,info_ptr,PNG_INFO_bKGD)) {
 	/* set the background to the one supplied */
-	png_set_background(png_ptr, &info_ptr->background,
+    	png_color_16p background;
+	png_get_bKGD(png_ptr,info_ptr,&background);
+	png_set_background(png_ptr, background,
 		PNG_BACKGROUND_GAMMA_FILE, 1, 1.0);
+    }
     else {
 	/* blend the canvas background using the alpha channel */
 	if (bgspec) {
