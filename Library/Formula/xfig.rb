require 'formula'

class Xfig < Formula
  url 'http://downloads.sourceforge.net/mcj/xfig.3.2.5b.full.tar.gz'
  version '3.2.5b'
  homepage 'http://www.xfig.org'
  sha1 '0730d7e6bc217c0de02682efb0078821512bb542'

  depends_on 'transfig'
  depends_on 'jpeg'
  depends_on 'ghostscript'
  depends_on 'imake' => :build
  depends_on :x11 => '2.7.2'

  def patches
    # Apply patch for Imakefile to remove spaces infront of #ifdefs
    #       this could make imake to ignore the #ifdefs.
    # Apply patch from macports trunk (@83426) to f_readeps.c to
    #       resolve bug inporting eps (https://trac.macports.org/ticket/27340).
    # Apply patch from macports trunk (@33558) to f_util.c to resolve
    #       crashing xfig if menubar is accessed (https://trac.macports.org/ticket/12044).
    # Apply patch from macports trunk (@70347) to fig.h to define extern
    #       subroutine srandom() for DARWIN systems.
    # Apply patch from macports trunk (@70347) to w_keyboard.c to ensure that
    #       REG_NOERROR is defined also in DARWIN systems
    # Apply patch from macports trunk (@97305) to f_readpng.c and fwrpng.c to fix
    #       build with libpng 1.5 using patch from Debian.
    # Apply patch from macports trunk (@96209) to main.c to set return value
    #       of main() to int. This fixes building with clang. (https://trac.macports.org/ticket/35406)
    # Apply patch from macports trunk (@96011) to w_export.c, w_print.c and w_util.c to fix
    #       problem with Mountain Lion 10.8 (https://trac.macports.org/ticket/35384)
    DATA
  end

  def install
    # Patch file attributs of Library directory
    system "chmod u+x Libraries"
    # Patch file attributes for xfig-title.png
    system "chmod u+r Doc/html/images/xfig-title.png"

    # Patch Imakefile to setup insatllation and library paths
    inreplace "Imakefile", "XCOMM BINDIR = /usr/bin",
              "BINDIR = #{bin}\n"     # set install dir for bin
    inreplace "Imakefile", "XCOMM XAPPLOADDIR = /home/user/xfig",
              "XAPPLOADDIR = #{lib}/X11/app-defaults\n"+
              "CONFDIR = #{lib}/X11"
    inreplace "Imakefile", "XCOMM #define XAW3D1_5E", "#define XAW3D1_5E"
    inreplace "Imakefile", "PNGLIBDIR = $(USRLIBDIR)","PNGLIBDIR = #{MacOS::X11.lib}"
    inreplace "Imakefile", "PNGINC = -I/usr/local/include","PNGINC = -I#{MacOS::X11.include}"
    inreplace "Imakefile", "ZLIBDIR = $(USRLIBDIR)", "ZLIBDIR = /usr/lib"
    inreplace "Imakefile", "JPEGLIBDIR = /usr/local/lib", "JPEGLIBDIR = #{HOMEBREW_PREFIX}/lib"
    inreplace "Imakefile", "JPEGINC = -I/usr/include/X11", "JPEGINC = -I#{HOMEBREW_PREFIX}/include"
    inreplace "Imakefile", "XPMLIBDIR = /usr/local/lib", "XPMLIBDIR = #{MacOS::X11.lib}"
    inreplace "Imakefile", "XPMINC = -I/usr/local/include/X11", "XPMINC = -I#{MacOS::X11.include}/X11"
    inreplace "Imakefile", "XFIGLIBDIR = $(LIBDIR)/xfig", "XFIGLIBDIR = #{lib}/X11/xfig"
    inreplace "Imakefile", "XFIGDOCDIR = /usr/local/xfig/doc", "XFIGDOCDIR = #{share}/doc/xfig"
    inreplace "Imakefile", "MANDIR = $(MANSOURCEPATH)$(MANSUFFIX)",
              "MANDIR = #{man}$(MANSUFFIX)"

    # make shuer that app-defaults directory exists in #{HOMEBREW_PREFIX}/lib/X11
    system "mkdirhier #{HOMEBREW_PREFIX}/lib/X11/app-defaults"

    # build make files
    system "xmkmf"
    system "make clean"

    # w_fontpanel.o must be build without optimization with gcc 4.2
    # see http://old.nabble.com/Fwd%3A-xfig-font-problem-td28885362.html
    gcc_version_str =`/usr/bin/cc --version | grep GCC | grep 4.2.`
    if gcc_version_str.length > 0
      ohai "Compiling w_fontpanel.c without optimization\n"
      system "make CDEBUGFLAGS=-O0 w_fontpanel.o"
    end

    # build xfig
    system "make"

    # patch Makefile to avoid building symlink /usr/local/X11/app-defaults
    inreplace "Makefile", "	  $(LN) $${RELPATH}$(CONFDIR)/app-defaults .;", "	  "

    # install xfig
    system "make install.all"
    system "make install.man"

    # generate launch script to point environment variable XAPPLRESDIR to the app_defaults file for xfig
    system "mv #{bin}/xfig #{bin}/../xfig.bin"
    File.open("#{bin}/xfig",'w') {|f| f.write("#!/bin/sh\n"+
                                              "export XAPPLRESDIR=#{HOMEBREW_PREFIX}/lib/X11/app-defaults\n"+
                                              "#{bin}/../xfig.bin\n")}
    system "chmod u+x #{bin}/xfig"

    # link fig2dev bitmaps to XFIGLIBDIR
    system "ln -s #{HOMEBREW_PREFIX}/opt/transfig/share/bitmaps #{lib}/X11/xfig/"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test xfig`.
    system "xfig"
  end
end

__END__
diff --git a/Imakefile b/Imakefile
index 2a8c753..97e18b1 100644
--- a/Imakefile
+++ b/Imakefile
@@ -63,13 +63,13 @@ XCOMM NOTE: This is the default for many X systems now.
 XCOMM #define XAW3D1_5E
 
 #ifdef XAW3D1_5E
-    DUSEXAW3D = -DXAW3D -DXAW3D1_5E
+DUSEXAW3D = -DXAW3D -DXAW3D1_5E
 #else
-    XAW_SRC = w_menuentry.c SmeCascade.c SmeBSB.c SimpleMenu.c
-    XAW_OBJ = w_menuentry.o SmeCascade.o SmeBSB.o SimpleMenu.o
-#   ifdef XAW3D
-	DUSEXAW3D = -DXAW3D
-#   endif /* XAW3D */
+XAW_SRC = w_menuentry.c SmeCascade.c SmeBSB.c SimpleMenu.c
+XAW_OBJ = w_menuentry.o SmeCascade.o SmeBSB.o SimpleMenu.o
+#ifdef XAW3D
+DUSEXAW3D = -DXAW3D
+#endif /* XAW3D */
 #endif /* XAW3D1_5E */
 
 XCOMM Redefine the following if your PNG library, zlib library and/or include file
@@ -95,13 +95,13 @@ XCOMM You must have version 5b or newer of the jpeg library.
 #define USEINSTALLEDJPEG
 
 #ifdef USEJPEG
-    #ifdef USEINSTALLEDJPEG
-	JPEGLIBDIR = /usr/local/lib
-	JPEGINC = -I/usr/include/X11
-    #else
-	JPEGLIBDIR = ../jpeg
-	JPEGINC = -I$(JPEGLIBDIR)
-    #endif /* USEINSTALLEDJPEG */
+#ifdef USEINSTALLEDJPEG
+JPEGLIBDIR = /usr/local/lib
+JPEGINC = -I/usr/include/X11
+#else
+JPEGLIBDIR = ../jpeg
+JPEGINC = -I$(JPEGLIBDIR)
+#endif /* USEINSTALLEDJPEG */
 #endif /* USEJPEG */
 
 XCOMM Uncomment the #define for USEXPM if you want to use the XPM
diff --git a/f_readeps.c b/f_readeps.c
index 35d13b7..47ea628 100644
--- a/f_readeps.c
+++ b/f_readeps.c
@@ -318,8 +318,8 @@ bitmap_from_gs(file, filetype, pic, urx, llx, ury, lly, pdf_flag)
 	gscom[0] = '\0';
     }
     sprintf(&gscom[strlen(gscom)],
-	    "%s -r72x72 -dSAFER -sDEVICE=%s -g%dx%d -sOutputFile=%s -q - > %s 2>&1",
-	    appres.ghostscript, driver, wid, ht, pixnam, errnam);
+	    "%s -r72x72 -dNOSAFER -sDEVICE=%s -g%dx%d -sOutputFile=%s -c '<</PermitFileReading[(%s)]>> setuserparams .locksafe' -q - > %s 2>&1",
+	    appres.ghostscript, driver, wid, ht, pixnam, psnam, errnam);
     if (appres.DEBUG)
 	fprintf(stderr,"calling: %s\n",gscom);
     if ((gsfile = popen(gscom, "w")) == 0) {
diff --git a/f_readpng.c b/f_readpng.c
index e4200b0..07d8ffd 100644
--- a/f_readpng.c
+++ b/f_readpng.c
@@ -43,7 +43,7 @@ read_png(FILE *file, int filetype, F_pic *pic)
     char	   *ptr;
     int		    num_palette;
     png_colorp	    palette;
-    png_color_16    background;
+    png_color_16    background, *image_background;
 
     /* make scale factor smaller for metric */
     float scale = (appres.INCHES ?
@@ -73,7 +73,7 @@ read_png(FILE *file, int filetype, F_pic *pic)
     }
 
     /* set long jump recovery here */
-    if (setjmp(png_ptr->jmpbuf)) {
+    if (setjmp(png_jmpbuf((png_ptr)))) {
 	/* if we get here there was a problem reading the file */
 	png_destroy_read_struct(&png_ptr, &info_ptr, &end_info);
 	close_picfile(file,filetype);
@@ -90,14 +90,18 @@ read_png(FILE *file, int filetype, F_pic *pic)
     png_get_IHDR(png_ptr, info_ptr, &w, &h, &bit_depth, &color_type,
 	&interlace_type, &compression_type, &filter_type);
 
-    if (info_ptr->valid & PNG_INFO_gAMA)
-	png_set_gamma(png_ptr, 2.2, info_ptr->gamma);
-    else
+    if (png_get_valid(png_ptr, info_ptr, PNG_INFO_gAMA)) {
+	double gamma;
+	png_get_gAMA(png_ptr, info_ptr, &gamma);
+	png_set_gamma(png_ptr, 2.2, gamma);
+	} else {
 	png_set_gamma(png_ptr, 2.2, 0.45);
+	}
 
-    if (info_ptr->valid & PNG_INFO_bKGD)
+    if (png_get_valid(png_ptr, info_ptr, PNG_INFO_bKGD) && 
+        png_get_bKGD(png_ptr, info_ptr, &image_background))
 	/* set the background to the one supplied */
-	png_set_background(png_ptr, &info_ptr->background,
+	png_set_background(png_ptr, image_background,
 		PNG_BACKGROUND_GAMMA_FILE, 1, 1.0);
     else {
 	/* blend the canvas background using the alpha channel */
@@ -136,7 +140,7 @@ read_png(FILE *file, int filetype, F_pic *pic)
 
 	if (png_get_PLTE(png_ptr, info_ptr, &palette, &num_palette)) {
 	    png_get_hIST(png_ptr, info_ptr, &histogram);
-	    png_set_dither(png_ptr, palette, num_palette, 256, histogram, 0);
+	    png_set_quantize(png_ptr, palette, num_palette, 256, histogram, 0);
 	}
     }
     if (color_type == PNG_COLOR_TYPE_GRAY || color_type == PNG_COLOR_TYPE_GRAY_ALPHA) {
diff --git a/f_util.c b/f_util.c
index f575efe..a929d49 100644
--- a/f_util.c
+++ b/f_util.c
@@ -781,7 +781,7 @@ uncompress_file(char *name)
     else strcpy(dirname, ".");
 
     if (access(dirname, W_OK) == 0) {  /* OK - the directory is writable */
-      sprintf(unc, "gunzip -q %s", name);
+      sprintf(unc, "gunzip -q -- %s", name);
       if (system(unc) != 0)
 	file_msg("Couldn't uncompress the file: \"%s\"", unc);
       strcpy(name, plainname);
@@ -792,7 +792,7 @@ uncompress_file(char *name)
 	  sprintf(tmpfile, "%s%s", TMPDIR, c);
       else
 	  sprintf(tmpfile, "%s/%s", TMPDIR, plainname);
-      sprintf(unc, "gunzip -q -c %s > %s", name, tmpfile);
+      sprintf(unc, "gunzip -q -c -- %s > %s", name, tmpfile);
       if (system(unc) != 0)
 	  file_msg("Couldn't uncompress the file: \"%s\"", unc);
       file_msg ("Uncompressing file %s in %s because it is in a read-only directory",
diff --git a/f_wrpng.c b/f_wrpng.c
index b3d8c85..9394998 100644
--- a/f_wrpng.c
+++ b/f_wrpng.c
@@ -20,6 +20,7 @@
 #include "w_msgpanel.h"
 #include "w_setup.h"
 #include <png.h>
+#include <zlib.h>
 
 /*
  * Write PNG file from rgb data
@@ -59,7 +60,7 @@ write_png(FILE *file, unsigned char *data, int type, unsigned char *Red, unsigne
     }
 
     /* set long jump recovery here */
-    if (setjmp(png_ptr->jmpbuf)) {
+	if (setjmp(png_jmpbuf((png_ptr)))) {
 	/* if we get here there was a problem reading the file */
 	png_destroy_write_struct(&png_ptr, &info_ptr);
 	return False;
diff --git a/fig.h b/fig.h
index 2e3f309..814e7aa 100644
--- a/fig.h
+++ b/fig.h
@@ -374,6 +374,9 @@ extern	double		drand48();
 extern	long		random();
 extern	void		srandom(unsigned int);
 
+#elif defined(__DARWIN__)
+extern  void            srandom();
+
 #elif !defined(__osf__) && !defined(__CYGWIN__) && !defined(linux) && !defined(__FreeBSD__) && !defined(__GLIBC__)
 extern	void		srandom(int);
 
diff --git a/main.c b/main.c
index 7ecaf68..3261e05 100644
--- a/main.c
+++ b/main.c
@@ -629,7 +629,7 @@ struct  geom   geom;
 int setup_visual (int *argc_p, char **argv, Arg *args);
 void get_pointer_mapping (void);
 
-void main(int argc, char **argv)
+int main(int argc, char **argv)
 {
     Widget	    children[NCHILDREN];
     XEvent	    event;
diff --git a/w_export.c b/w_export.c
index b8edf3e..47373dd 100644
--- a/w_export.c
+++ b/w_export.c
@@ -1016,7 +1016,7 @@ toggle_hpgl_pcl_switch(Widget w, XtPointer closure, XtPointer call_data)
     /* set global state */
     print_hpgl_pcl_switch = state;
 
-    return;
+    return 0;
 }
 
 static XtCallbackProc
@@ -1038,7 +1038,7 @@ toggle_hpgl_font(Widget w, XtPointer closure, XtPointer call_data)
     /* set global state */
     hpgl_specified_font = state;
 
-    return;
+    return 0;
 }
 
 void create_export_panel(Widget w)
diff --git a/w_keyboard.c b/w_keyboard.c
index 6655d08..23a5732 100644
--- a/w_keyboard.c
+++ b/w_keyboard.c
@@ -45,6 +45,10 @@
 #define REG_NOERROR 0
 #endif
 
+#ifndef REG_NOERROR
+#define REG_NOERROR 0
+#endif
+
 Boolean keyboard_input_available = False;
 int keyboard_x;
 int keyboard_y;
diff --git a/w_print.c b/w_print.c
index 4eab2be..148611d 100644
--- a/w_print.c
+++ b/w_print.c
@@ -1185,7 +1185,7 @@ switch_print_layers(Widget w, XtPointer closure, XtPointer call_data)
     /* which button */
     which = (int) XawToggleGetCurrent(w);
     if (which == 0)		/* no buttons on, in transition so return now */
-	return;
+	return 0;
     if (which == 2)		/* "blank" button, invert state */
 	state = !state;
 
@@ -1193,7 +1193,7 @@ switch_print_layers(Widget w, XtPointer closure, XtPointer call_data)
     print_all_layers = state;
     update_figure_size();
 
-    return;
+    return 0;
 }
 
 /* when user toggles between printing all or only active layers */
diff --git a/w_util.c b/w_util.c
index b24d07c..097eb92 100644
--- a/w_util.c
+++ b/w_util.c
@@ -710,7 +710,7 @@ start_spin_timer(Widget widget, XtPointer data, XEvent event)
     /* keep track of which one the user is pressing */
     cur_spin = widget;
 
-    return;
+    return 0;
 }
 
 static XtEventHandler
@@ -718,7 +718,7 @@ stop_spin_timer(int widget, int data, int event)
 {
     XtRemoveTimeOut(auto_spinid);
 
-    return;
+    return 0;
 }
 
 static	XtTimerCallbackProc
@@ -729,7 +729,7 @@ auto_spin(XtPointer client_data, XtIntervalId *id)
     /* call the proper spinup/down routine */
     XtCallCallbacks(cur_spin, XtNcallback, 0);
 
-    return;
+    return 0;
 }
 
 /***************************/
@@ -1412,7 +1412,7 @@ toggle_checkbutton(Widget w, XtPointer data, XtPointer garbage)
     }
     SetValues(w);
 
-    return;
+    return 0;
 }
 
 /* assemble main window title bar with xfig title and (base) file name */
