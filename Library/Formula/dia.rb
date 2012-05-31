require 'formula'

class Dia < Formula
  homepage 'http://live.gnome.org/Dia'
  url 'http://ftp.gnome.org/pub/gnome/sources/dia/0.97/dia-0.97.2.tar.xz'
  sha256 'a761478fb98697f71b00d3041d7c267f3db4b94fe33ac07c689cb89c4fe5eae1'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'intltool'
  depends_on 'gettext'
  depends_on 'pango'
  depends_on 'libtiff'
  depends_on 'gtk+'

  def patches
    # fixes compilation with glib 2.31+
    # see https://bugzilla.gnome.org/show_bug.cgi?id=665335
    # fixed in master branch, should be removable in next release
    DATA
  end

  def install
    ENV.x11
    # fix for Leopard, potentially others with isspecial defined elswhere
    inreplace 'objects/GRAFCET/boolequation.c', 'isspecial', 'char_isspecial'
    system "./configure", "--enable-debug=no",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    rm_rf share+"applications"
  end
end

__END__
diff --git a/objects/custom/shape_typeinfo.c b/objects/custom/shape_typeinfo.c
index c6133b1..3fb3d73 100644
--- a/objects/custom/shape_typeinfo.c
+++ b/objects/custom/shape_typeinfo.c
@@ -27,7 +27,7 @@
 #include "custom_util.h"
 #include <string.h>
 #include <stdarg.h>
-#include <glib/gstrfuncs.h>
+#include <glib.h>
 #include <glib/gstdio.h>
 #include <libxml/parser.h>
 
diff --git a/plug-ins/pgf/render_pgf.c b/plug-ins/pgf/render_pgf.c
index 3fe5bbd..24b812e 100644
--- a/plug-ins/pgf/render_pgf.c
+++ b/plug-ins/pgf/render_pgf.c
@@ -61,7 +61,7 @@ TODO:
 #endif
 #include <errno.h>
 
-#include <glib/gprintf.h>
+#include <glib.h>
 #include <glib/gstdio.h>
 
 #include "intl.h"
diff --git a/tests/test-boundingbox.c b/tests/test-boundingbox.c
index 7adaab5..a13d018 100644
--- a/tests/test-boundingbox.c
+++ b/tests/test-boundingbox.c
@@ -28,9 +28,6 @@
 #include <glib.h>
 #include <glib-object.h>
 
-#if GLIB_CHECK_VERSION(2,16,0)
-#include <glib/gtestutils.h>
-#endif
 #include "dialib.h"
 
 /*
diff --git a/tests/test-objects.c b/tests/test-objects.c
index 57d5675..c5980a5 100644
--- a/tests/test-objects.c
+++ b/tests/test-objects.c
@@ -28,10 +28,6 @@
 #include <glib.h>
 #include <glib-object.h>
 
-#if GLIB_CHECK_VERSION(2,16,0)
-#include <glib/gtestutils.h>
-#endif
-
 #include "object.h"
 #include "plug-ins.h"
 #include "dialib.h"
