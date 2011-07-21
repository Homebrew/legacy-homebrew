require 'formula'

class GhostscriptFonts < Formula
  url 'http://downloads.sourceforge.net/project/gs-fonts/gs-fonts/8.11%20%28base%2035%2C%20GPL%29/ghostscript-fonts-std-8.11.tar.gz'
  homepage 'http://sourceforge.net/projects/gs-fonts/'
  md5 '6865682b095f8c4500c54b285ff05ef6'
end

class Ghostscript < Formula
  url 'http://downloads.ghostscript.com/public/ghostscript-9.02.tar.bz2'
  homepage 'http://www.ghostscript.com/'
  md5 'f67151444bd56a7904579fc75a083dd6'

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'lcms'
  depends_on 'jasper'

  def patches; DATA; end

  def move_included_source_copies
    # If the install version of any of these doesn't match
    # the version included in ghostscript, we get errors
    # Taken from the MacPorts portfile - http://bit.ly/ghostscript-portfile
    renames = [ "jpeg", "libpng", "zlib", "jasper", "lcms", "expat", "tiff" ]
    renames << "freetype" if 10.7 <= MACOS_VERSION
    renames.each do |lib|
      mv lib, "#{lib}_local"
    end
  end

  def install
    ENV.libpng
    ENV.deparallelize
    # O4 takes an ungodly amount of time
    ENV.O3
    # ghostscript configure ignores LDFLAGs apparently
    ENV['LIBS']="-L/usr/X11/lib"

    move_included_source_copies

    system "./configure", "--prefix=#{prefix}", "--disable-debug",
                          # the cups component adamantly installs to /usr so fuck it
                          "--disable-cups",
                          "--disable-compile-inits",
                          "--disable-gtk"

    # versioned stuff in main tree is pointless for us
    inreplace 'Makefile', '/$(GS_DOT_VERSION)', ''
    system "make install"

    GhostscriptFonts.new.brew do
      Dir.chdir '..'
      (share+'ghostscript').install 'fonts'
    end

    (man+'de').rmtree
  end
end

__END__
--- a/base/gdevpng.c
+++ b/base/gdevpng.c
@@ -260,7 +260,7 @@ png_print_page(gx_device_printer * pdev, FILE * file)
 {
     gs_memory_t *mem = pdev->memory;
     int raster = gdev_prn_raster(pdev);
-
+    
     /* PNG structures */
     byte *row = gs_alloc_bytes(mem, raster, "png raster buffer");
     png_struct *png_ptr =
@@ -274,134 +274,156 @@ png_print_page(gx_device_printer * pdev, FILE * file)
     char software_key[80];
     char software_text[256];
     png_text text_png;
-
+#if PNG_LIBPNG_VER >= 10500
+    int color_type = 0;
+    png_color* palette = NULL;
+#define PNG_SET_IHDR(bit, color) \
+    png_set_IHDR(png_ptr, info_ptr, pdev->width, pdev->height, (bit), (color_type = (color)), \
+                 PNG_INTERLACE_NONE, PNG_COMPRESSION_TYPE_DEFAULT, PNG_FILTER_TYPE_DEFAULT);
+#define COLOR_TYPE color_type
+#define PALETTE palette
+#define PNG_JMPBUF png_jmpbuf(png_ptr)
+#else
+#define PNG_SET_IHDR(bit, color) \
+    info_ptr->bit_depth = (bit); \
+    info_ptr->color_type = (color);
+#define COLOR_TYPE info_ptr->color_type
+#define PALETTE info_ptr->palette
+#define PNG_JMPBUF info_ptr->jmpbuf
+#endif
+    
     if (row == 0 || png_ptr == 0 || info_ptr == 0) {
-	code = gs_note_error(gs_error_VMerror);
-	goto done;
+        code = gs_note_error(gs_error_VMerror);
+        goto done;
     }
     /* set error handling */
-    if (setjmp(png_ptr->jmpbuf)) {
-	/* If we get here, we had a problem reading the file */
-	code = gs_note_error(gs_error_VMerror);
-	goto done;
+    if (setjmp(PNG_JMPBUF)) {
+        /* If we get here, we had a problem reading the file */
+        code = gs_note_error(gs_error_VMerror);
+        goto done;
     }
     code = 0;			/* for normal path */
     /* set up the output control */
     png_init_io(png_ptr, file);
-
+    
+#if PNG_LIBPNG_VER >= 10500
+    png_set_pHYs(png_ptr, info_ptr, 
+                 (png_uint_32) (pdev->HWResolution[0] * (100.0 / 2.54)),
+                 (png_uint_32) (pdev->HWResolution[1] * (100.0 / 2.54)),
+                 PNG_RESOLUTION_METER);
+#else
     /* set the file information here */
     info_ptr->width = pdev->width;
     info_ptr->height = pdev->height;
     /* resolution is in pixels per meter vs. dpi */
-    info_ptr->x_pixels_per_unit =
-	(png_uint_32) (pdev->HWResolution[0] * (100.0 / 2.54));
-    info_ptr->y_pixels_per_unit =
-	(png_uint_32) (pdev->HWResolution[1] * (100.0 / 2.54));
+    info_ptr->x_pixels_per_unit = (png_uint_32) (pdev->HWResolution[0] * (100.0 / 2.54));
+    info_ptr->y_pixels_per_unit = (png_uint_32) (pdev->HWResolution[1] * (100.0 / 2.54));
     info_ptr->phys_unit_type = PNG_RESOLUTION_METER;
     info_ptr->valid |= PNG_INFO_pHYs;
+#endif
     switch (depth) {
-	case 32:
-	    info_ptr->bit_depth = 8;
-	    info_ptr->color_type = PNG_COLOR_TYPE_RGB_ALPHA;
-	    png_set_invert_alpha(png_ptr);
+        case 32:
+            PNG_SET_IHDR(8, PNG_COLOR_TYPE_RGB_ALPHA);
+            png_set_invert_alpha(png_ptr);
 	    {   gx_device_pngalpha *ppdev = (gx_device_pngalpha *)pdev;
-		png_color_16 background;
-		background.index = 0;
-		background.red =   (ppdev->background >> 16) & 0xff;
-		background.green = (ppdev->background >> 8)  & 0xff;
-		background.blue =  (ppdev->background)       & 0xff;
-		background.gray = 0;
-		png_set_bKGD(png_ptr, info_ptr, &background);
+            png_color_16 background;
+            background.index = 0;
+            background.red =   (ppdev->background >> 16) & 0xff;
+            background.green = (ppdev->background >> 8)  & 0xff;
+            background.blue =  (ppdev->background)       & 0xff;
+            background.gray = 0;
+            png_set_bKGD(png_ptr, info_ptr, &background);
 	    }
-	    break;
-	case 48:
-	    info_ptr->bit_depth = 16;
-	    info_ptr->color_type = PNG_COLOR_TYPE_RGB;
+            break;
+        case 48:
+            PNG_SET_IHDR(16, PNG_COLOR_TYPE_RGB);
 #if defined(ARCH_IS_BIG_ENDIAN) && (!ARCH_IS_BIG_ENDIAN) 
-	    png_set_swap(png_ptr);
+            png_set_swap(png_ptr);
 #endif
-	    break;
-	case 24:
-	    info_ptr->bit_depth = 8;
-	    info_ptr->color_type = PNG_COLOR_TYPE_RGB;
-	    break;
-	case 8:
-	    info_ptr->bit_depth = 8;
-	    if (gx_device_has_color(pdev))
-		info_ptr->color_type = PNG_COLOR_TYPE_PALETTE;
-	    else
-		info_ptr->color_type = PNG_COLOR_TYPE_GRAY;
-	    break;
-	case 4:
-	    info_ptr->bit_depth = 4;
-	    info_ptr->color_type = PNG_COLOR_TYPE_PALETTE;
-	    break;
-	case 1:
-	    info_ptr->bit_depth = 1;
-	    info_ptr->color_type = PNG_COLOR_TYPE_GRAY;
-	    /* invert monocrome pixels */
-	    png_set_invert_mono(png_ptr);
-	    break;
+            break;
+        case 24:
+            PNG_SET_IHDR(8, PNG_COLOR_TYPE_RGB);
+            break;
+        case 8:
+            PNG_SET_IHDR(8, (gx_device_has_color(pdev) ? PNG_COLOR_TYPE_PALETTE : PNG_COLOR_TYPE_GRAY));
+        case 4:
+            PNG_SET_IHDR(4, PNG_COLOR_TYPE_PALETTE);
+            break;
+        case 1:
+            PNG_SET_IHDR(1, PNG_COLOR_TYPE_GRAY);
+            /* invert monocrome pixels */
+            png_set_invert_mono(png_ptr);
+            break;
     }
-
+    
     /* set the palette if there is one */
-    if (info_ptr->color_type == PNG_COLOR_TYPE_PALETTE) {
-	int i;
-	int num_colors = 1 << depth;
-	gx_color_value rgb[3];
-
-	info_ptr->palette =
-	    (void *)gs_alloc_bytes(mem, 256 * sizeof(png_color),
-				   "png palette");
-	if (info_ptr->palette == 0) {
-	    code = gs_note_error(gs_error_VMerror);
-	    goto done;
-	}
-	info_ptr->num_palette = num_colors;
-	info_ptr->valid |= PNG_INFO_PLTE;
-	for (i = 0; i < num_colors; i++) {
-	    (*dev_proc(pdev, map_color_rgb)) ((gx_device *) pdev,
-					      (gx_color_index) i, rgb);
-	    info_ptr->palette[i].red = gx_color_value_to_byte(rgb[0]);
-	    info_ptr->palette[i].green = gx_color_value_to_byte(rgb[1]);
-	    info_ptr->palette[i].blue = gx_color_value_to_byte(rgb[2]);
-	}
+    if (COLOR_TYPE == PNG_COLOR_TYPE_PALETTE) {
+        int i;
+        int num_colors = 1 << depth;
+        gx_color_value rgb[3];
+        
+        PALETTE = (void *)gs_alloc_bytes(mem, 256 * sizeof(png_color),
+                               "png palette");
+        if (PALETTE == 0) {
+            code = gs_note_error(gs_error_VMerror);
+            goto done;
+        }
+#if PNG_LIBPNG_VER < 10500
+        info_ptr->num_palette = num_colors;
+        info_ptr->valid |= PNG_INFO_PLTE;
+#endif
+        for (i = 0; i < num_colors; i++) {
+            (*dev_proc(pdev, map_color_rgb)) ((gx_device *) pdev,
+                                              (gx_color_index) i, rgb);
+            PALETTE[i].red = gx_color_value_to_byte(rgb[0]);
+            PALETTE[i].green = gx_color_value_to_byte(rgb[1]);
+            PALETTE[i].blue = gx_color_value_to_byte(rgb[2]);
+        }
+#if PNG_LIBPNG_VER >= 10500
+        png_set_PLTE(png_ptr, info_ptr, PALETTE, num_colors);
+#endif
     }
     /* add comment */
     strncpy(software_key, "Software", sizeof(software_key));
     sprintf(software_text, "%s %d.%02d", gs_product,
-	    (int)(gs_revision / 100), (int)(gs_revision % 100));
-    text_png.compression = -1;	/* uncompressed */
+            (int)(gs_revision / 100), (int)(gs_revision % 100));
+    text_png.compression = PNG_TEXT_COMPRESSION_NONE;	/* uncompressed */
     text_png.key = software_key;
     text_png.text = software_text;
     text_png.text_length = strlen(software_text);
+#if PNG_LIBPNG_VER >= 10500
+    png_set_text(png_ptr, info_ptr, &text_png, 1); 
+#else
     info_ptr->text = &text_png;
     info_ptr->num_text = 1;
-
+#endif
+    
     /* write the file information */
     png_write_info(png_ptr, info_ptr);
-
+    
+#if PNG_LIBPNG_VER < 10500
     /* don't write the comments twice */
     info_ptr->num_text = 0;
     info_ptr->text = NULL;
-
+#endif
+    
     /* Write the contents of the image. */
     for (y = 0; y < height; y++) {
-	gdev_prn_copy_scan_lines(pdev, y, row, raster);
-	png_write_rows(png_ptr, &row, 1);
+        gdev_prn_copy_scan_lines(pdev, y, row, raster);
+        png_write_rows(png_ptr, &row, 1);
     }
-
+    
     /* write the rest of the file */
     png_write_end(png_ptr, info_ptr);
-
+    
     /* if you alloced the palette, free it here */
-    gs_free_object(mem, info_ptr->palette, "png palette");
-
-  done:
+    gs_free_object(mem, PALETTE, "png palette");
+    
+done:
     /* free the structures */
     png_destroy_write_struct(&png_ptr, &info_ptr);
     gs_free_object(mem, row, "png raster buffer");
-
+    
     return code;
 }
 

diff --git a/base/Makefile.in b/base/Makefile.in
index 5b7847d..85e1a32 100644
--- a/base/Makefile.in
+++ b/base/Makefile.in
@@ -362,7 +362,7 @@ LDFLAGS=@LDFLAGS@ $(XLDFLAGS)
 # Solaris may need -lnsl -lsocket -lposix4.
 # (Libraries required by individual drivers are handled automatically.)
 
-EXTRALIBS=@LIBS@ @DYNAMIC_LIBS@ @FONTCONFIG_LIBS@
+EXTRALIBS=@LIBS@ @DYNAMIC_LIBS@ @FONTCONFIG_LIBS@ @FT_LIBS@
 
 # Define the standard libraries to search at the end of linking.
 # Most platforms require -lpthread for the POSIX threads library;

