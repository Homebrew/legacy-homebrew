class Libgdiplus < Formula
  desc "C-based implementation of the GDI+ API for Mono"
  homepage "http://www.mono-project.com/docs/gui/libgdiplus/"
  version "3.12"
  url "https://github.com/mono/libgdiplus/tarball/3b284ab28cb8737f9d14dabfedc6903655c66a7f"
  head "https://github.com/mono/libgdiplus.git"
  sha256 "c7b6e68f4f4ef62e1f7551769c7f0b87e7debd52311123a0264d23cf7ac9aee8"
  patch :DATA

  # it depends on mono to link to System.Drawing
  depends_on "libexif"
  depends_on "glib"
  depends_on "cairo"
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  # And it depends on mono to build, but this formula is specified as a resource
  # in that recipe.

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-tests",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "true"
  end
end

__END__
diff --git a/Makefile.am b/Makefile.am
index bb89e98..ca2cf51 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,4 +1,4 @@
-SUBDIRS = @CAIRO_DIR@ src tests
+SUBDIRS = @CAIRO_DIR@ src @TESTS_DIR@
 DIST_SUBDIRS = src tests
 
 pkgconfigdir = $(libdir)/pkgconfig
diff --git a/configure.ac b/configure.ac
index 772d5fc..54d8677 100644
--- a/configure.ac
+++ b/configure.ac
@@ -19,8 +19,8 @@ fi
 GLIB_REQUIRED_VERSION="2.2.3"
 PKG_CHECK_MODULES(BASE_DEPENDENCIES, glib-2.0 >= $GLIB_REQUIRED_VERSION)
 
-GDIPLUS_LIBS="`pkg-config --libs glib-2.0 `"
-GDIPLUS_CFLAGS="`pkg-config --cflags glib-2.0 `"
+GDIPLUS_LIBS="`$PKG_CONFIG --libs glib-2.0 `"
+GDIPLUS_CFLAGS="`$PKG_CONFIG --cflags glib-2.0 `"
 
 CAIRO_REQUIRED_VERSION="1.6.4"
 PKG_CHECK_MODULES(CAIRO, cairo >= $CAIRO_REQUIRED_VERSION)
@@ -122,8 +122,8 @@ esac
 
 # Add xrender here so that we don't fail to find glib if we won't have xrender.pc
 if test "x$no_x" != "xyes"; then
-   GDIPLUS_LIBS="$GDIPLUS_LIBS `pkg-config --libs xrender `"
-   GDIPLUS_CFLAGS="$GDIPLUS_CFLAGS `pkg-config --cflags xrender `"
+   GDIPLUS_LIBS="$GDIPLUS_LIBS `$PKG_CONFIG --libs xrender `"
+   GDIPLUS_CFLAGS="$GDIPLUS_CFLAGS `$PKG_CONFIG --cflags xrender `"
 fi
 
 # Apparently for BSD special handling needs to happen
@@ -363,17 +363,16 @@ else
 fi
 AM_CONDITIONAL(HAVE_LIBEXIF, test x$libexif_pkgconfig = xyes)
 
-dnl
-dnl Produce a diagnostic, to reduce support time
-dnl
-AC_TRY_COMPILE([#include <X11/Xlib.h>],
-            [],[x11_failed=false],[x11_failed=true])
-if $x11_failed; then
-   AC_ERROR("Failed to compile with X11/Xlib.h include.  You must fix your compiler paths")
-fi
-
 GDIPLUS_PKG_LIBS="$GDIPLUS_LIBS"
 GDIPLUS_PKG_CFLAGS="$GDIPLUS_CFLAGS"
+
+AC_ARG_ENABLE(tests, [AC_HELP_STRING([--disable-tests],
+             [ Disable building tests ])],
+             [disable_tests=yes])
+if test x$disable_tests != xyes ; then
+   TESTS_DIR=tests
+   AC_SUBST(TESTS_DIR)
+fi
  
 AC_SUBST(GDIPLUS_LIBS)
 AC_SUBST(GDIPLUS_CFLAGS)
diff --git a/src/gdiplus-private.h b/src/gdiplus-private.h
index dfccc02..8a409ad 100644
--- a/src/gdiplus-private.h
+++ b/src/gdiplus-private.h
@@ -64,7 +64,9 @@
    #endif
 #endif
 
+#ifdef CAIRO_HAS_XLIB_SURFACE
 #include <X11/Xlib.h>
+#endif
 
 #include "win32structs.h"
 #include "gdipenums.h"
diff --git a/src/general.c b/src/general.c
index 8a170ce..406b5aa 100644
--- a/src/general.c
+++ b/src/general.c
@@ -123,7 +123,6 @@ float
 gdip_get_display_dpi ()
 {
    static float dpis = 0;
-   Display* display;
 
    if (dpis == 0) {
 #if __APPLE__
@@ -132,7 +131,8 @@ gdip_get_display_dpi ()
 
        dpis = h_dpi;
        return dpis;
-#else
+#elif defined(CAIRO_HAS_XLIB_SURFACE)
+       Display* display;
        char *val;
 
        display = XOpenDisplay (0);
@@ -148,7 +148,9 @@ gdip_get_display_dpi ()
        } else {
            dpis = 96.0f;
        }
+       return dpis;
 #endif
+       dpis = 96.0f;
    }
 
    return dpis;
diff --git a/src/graphics-private.h b/src/graphics-private.h
index 25660c6..bdbc8a2 100644
--- a/src/graphics-private.h
+++ b/src/graphics-private.h
@@ -105,8 +105,10 @@ typedef struct _Graphics {
    cairo_t         *ct;
    GpMatrix        *copy_of_ctm;
    cairo_matrix_t      previous_matrix;
+#ifdef CAIRO_HAS_XLIB_SURFACE
    Display         *display;
    Drawable        drawable;
+#endif
    void            *image;
    int         type; 
    GpPen*          last_pen;   /* caching pen and brush to avoid unnecessary sets */
diff --git a/src/graphics.c b/src/graphics.c
index 16a29ea..71ad9b8 100644
--- a/src/graphics.c
+++ b/src/graphics.c
@@ -151,8 +151,10 @@ gdip_graphics_common_init (GpGraphics *graphics)
    graphics->render_origin_y = 0;
    graphics->dpi_x = graphics->dpi_y = 0;
 
+#ifdef CAIRO_HAS_XLIB_SURFACE
    graphics->display = NULL;
    graphics->drawable = NULL;
+#endif
 
    gdip_graphics_reset (graphics);
 }
@@ -216,7 +218,9 @@ GdipCreateFromHDC (void *hDC, GpGraphics **graphics)
    cairo_surface_t *surface;
    int x, y;
    unsigned int w, h, border_w, depth;
+#ifdef CAIRO_HAS_XLIB_SURFACE
    Window root;
+#endif
 
    if (!hDC)
        return OutOfMemory;
