require 'formula'

class Inkscape < Formula
  homepage 'http://inkscape.org/'
  url 'http://downloads.sourceforge.net/project/inkscape/inkscape/0.48.4/inkscape-0.48.4.tar.gz'
  sha1 'ce453cc9aff56c81d3b716020cd8cc7fa1531da0'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'boost-build' => :build
  depends_on 'gettext'
  depends_on 'bdw-gc'
  depends_on 'glibmm'
  depends_on 'gtkmm'
  depends_on 'gsl'
  depends_on 'boost'
  depends_on 'popt'
  depends_on 'little-cms'
  depends_on 'cairomm'
  depends_on 'pango'
  depends_on :x11

  fails_with :clang

  # Fix bad includes with gtkmm-2.24.3
  # Check if this is still needed with new versions of inkscape and gtkmm
  def patches; DATA end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-lcms",
                          "--disable-poppler-cairo"
    system "make install"
  end

  def test
    system "#{bin}/inkscape", "-V"
  end
end

__END__
diff -ru inkscape-0.48.4/src/application/application.cpp inkscape-FToU/inkscape-0.48.4/src/application/application.cpp
--- inkscape-0.48.4/src/application/application.cpp	2011-07-08 14:25:09.000000000 -0400
+++ inkscape-FToU/inkscape-0.48.4/src/application/application.cpp	2013-05-02 15:39:57.000000000 -0400
@@ -14,6 +14,7 @@
 # include <config.h>
 #endif

+#include <glibmm.h>
 #include <gtkmm/main.h>

 #include "preferences.h"
diff -ru inkscape-0.48.4/src/color-profile.cpp inkscape-FToU/inkscape-0.48.4/src/color-profile.cpp
--- inkscape-0.48.4/src/color-profile.cpp	2012-02-18 20:41:36.000000000 -0500
+++ inkscape-FToU/inkscape-0.48.4/src/color-profile.cpp	2013-05-02 13:55:48.000000000 -0400
@@ -6,6 +6,7 @@

 #include <glib/gstdio.h>
 #include <sys/fcntl.h>
+#include <glibmm.h>
 #include <gdkmm/color.h>
 #include <glib/gi18n.h>

diff -ru inkscape-0.48.4/src/device-manager.cpp inkscape-FToU/inkscape-0.48.4/src/device-manager.cpp
--- inkscape-0.48.4/src/device-manager.cpp	2011-07-08 14:25:09.000000000 -0400
+++ inkscape-FToU/inkscape-0.48.4/src/device-manager.cpp	2013-05-02 13:56:15.000000000 -0400
@@ -8,6 +8,7 @@
  */

 #include <glib.h>
+#include <glibmm.h>
 #include <map>
 #include <set>
 #include <gtk/gtk.h>
diff -ru inkscape-0.48.4/src/dropper-context.cpp inkscape-FToU/inkscape-0.48.4/src/dropper-context.cpp
--- inkscape-0.48.4/src/dropper-context.cpp	2012-12-13 12:00:46.000000000 -0500
+++ inkscape-FToU/inkscape-0.48.4/src/dropper-context.cpp	2013-05-02 13:57:05.000000000 -0400
@@ -16,6 +16,7 @@
 # include <config.h>
 #endif

+#include <glibmm.h>
 #include <glibmm/i18n.h>
 #include <glibmm/ustring.h>
 #include <glibmm/refptr.h>
diff -ru inkscape-0.48.4/src/extension/implementation/implementation.h inkscape-FToU/inkscape-0.48.4/src/extension/implementation/implementation.h
--- inkscape-0.48.4/src/extension/implementation/implementation.h	2011-07-08 14:25:09.000000000 -0400
+++ inkscape-FToU/inkscape-0.48.4/src/extension/implementation/implementation.h	2013-05-02 15:48:27.000000000 -0400
@@ -12,6 +12,7 @@
 #ifndef __INKSCAPE_EXTENSION_IMPLEMENTATION_H__
 #define __INKSCAPE_EXTENSION_IMPLEMENTATION_H__

+#include <glibmm.h>
 #include <gtk/gtk.h>
 #include <gdkmm/types.h>
 #include <gtkmm/widget.h>
diff -ru inkscape-0.48.4/src/inkview.cpp inkscape-FToU/inkscape-0.48.4/src/inkview.cpp
--- inkscape-0.48.4/src/inkview.cpp	2012-02-13 22:22:17.000000000 -0500
+++ inkscape-FToU/inkscape-0.48.4/src/inkview.cpp	2013-05-02 15:52:30.000000000 -0400
@@ -48,6 +48,7 @@
 #include <gdk/gdkkeysyms.h>
 #include <gtk/gtk.h>

+#include <glibmm.h>
 #include <gtkmm/main.h>

 #include "gc-core.h"
diff -ru inkscape-0.48.4/src/live_effects/parameter/array.h inkscape-FToU/inkscape-0.48.4/src/live_effects/parameter/array.h
--- inkscape-0.48.4/src/live_effects/parameter/array.h	2012-02-13 22:22:17.000000000 -0500
+++ inkscape-FToU/inkscape-0.48.4/src/live_effects/parameter/array.h	2013-05-02 15:56:45.000000000 -0400
@@ -13,6 +13,7 @@

 #include <glib.h>

+#include <glibmm.h>
 #include <gtkmm/tooltips.h>

 #include "live_effects/parameter/parameter.h"
diff -ru inkscape-0.48.4/src/live_effects/parameter/path.h inkscape-FToU/inkscape-0.48.4/src/live_effects/parameter/path.h
--- inkscape-0.48.4/src/live_effects/parameter/path.h	2012-02-13 22:22:17.000000000 -0500
+++ inkscape-FToU/inkscape-0.48.4/src/live_effects/parameter/path.h	2013-05-02 15:55:09.000000000 -0400
@@ -12,6 +12,7 @@
 #include <glib.h>
 #include <2geom/path.h>

+#include <glibmm.h>
 #include <gtkmm/tooltips.h>

 #include "live_effects/parameter/parameter.h"
diff -ru inkscape-0.48.4/src/live_effects/parameter/point.h inkscape-FToU/inkscape-0.48.4/src/live_effects/parameter/point.h
--- inkscape-0.48.4/src/live_effects/parameter/point.h	2012-02-13 22:22:17.000000000 -0500
+++ inkscape-FToU/inkscape-0.48.4/src/live_effects/parameter/point.h	2013-05-02 15:56:23.000000000 -0400
@@ -12,6 +12,7 @@
 #include <glib.h>
 #include <2geom/point.h>

+#include <glibmm.h>
 #include <gtkmm/tooltips.h>

 #include "live_effects/parameter/parameter.h"
diff -ru inkscape-0.48.4/src/live_effects/parameter/vector.h inkscape-FToU/inkscape-0.48.4/src/live_effects/parameter/vector.h
--- inkscape-0.48.4/src/live_effects/parameter/vector.h	2012-02-13 22:22:17.000000000 -0500
+++ inkscape-FToU/inkscape-0.48.4/src/live_effects/parameter/vector.h	2013-05-02 15:55:57.000000000 -0400
@@ -12,6 +12,7 @@
 #include <glib.h>
 #include <2geom/point.h>

+#include <glibmm.h>
 #include <gtkmm/tooltips.h>

 #include "live_effects/parameter/parameter.h"
diff -ru inkscape-0.48.4/src/selection-chemistry.cpp inkscape-FToU/inkscape-0.48.4/src/selection-chemistry.cpp
--- inkscape-0.48.4/src/selection-chemistry.cpp	2012-02-13 22:22:17.000000000 -0500
+++ inkscape-FToU/inkscape-0.48.4/src/selection-chemistry.cpp	2013-05-02 15:22:30.000000000 -0400
@@ -26,6 +26,7 @@
 SPCycleType SP_CYCLING = SP_CYCLE_FOCUS;


+#include <glibmm.h>
 #include <gtkmm/clipboard.h>

 #include "svg/svg.h"
diff -ru inkscape-0.48.4/src/text-context.cpp inkscape-FToU/inkscape-0.48.4/src/text-context.cpp
--- inkscape-0.48.4/src/text-context.cpp	2011-07-08 14:25:09.000000000 -0400
+++ inkscape-FToU/inkscape-0.48.4/src/text-context.cpp	2013-05-02 15:38:35.000000000 -0400
@@ -17,6 +17,7 @@
 # include <config.h>
 #endif

+#include <glibmm.h>
 #include <gdk/gdkkeysyms.h>
 #include <gtk/gtk.h>
 #include <display/sp-ctrlline.h>
diff -ru inkscape-0.48.4/src/ui/clipboard.cpp inkscape-FToU/inkscape-0.48.4/src/ui/clipboard.cpp
--- inkscape-0.48.4/src/ui/clipboard.cpp	2012-02-13 22:22:17.000000000 -0500
+++ inkscape-FToU/inkscape-0.48.4/src/ui/clipboard.cpp	2013-05-02 15:58:50.000000000 -0400
@@ -23,6 +23,7 @@

 #include <list>
 #include <algorithm>
+#include <glibmm.h>
 #include <gtkmm/clipboard.h>
 #include <glibmm/ustring.h>
 #include <glibmm/i18n.h>
diff -ru inkscape-0.48.4/src/ui/dialog/inkscape-preferences.cpp inkscape-FToU/inkscape-0.48.4/src/ui/dialog/inkscape-preferences.cpp
--- inkscape-0.48.4/src/ui/dialog/inkscape-preferences.cpp	2012-12-13 12:00:46.000000000 -0500
+++ inkscape-FToU/inkscape-0.48.4/src/ui/dialog/inkscape-preferences.cpp	2013-05-02 15:59:56.000000000 -0400
@@ -17,6 +17,7 @@
 # include <config.h>
 #endif

+#include <glibmm.h>
 #include <gtkmm/main.h>
 #include <gtkmm/frame.h>
 #include <gtkmm/scrolledwindow.h>
diff -ru inkscape-0.48.4/src/ui/dialog/memory.cpp inkscape-FToU/inkscape-0.48.4/src/ui/dialog/memory.cpp
--- inkscape-0.48.4/src/ui/dialog/memory.cpp	2011-07-08 14:25:09.000000000 -0400
+++ inkscape-FToU/inkscape-0.48.4/src/ui/dialog/memory.cpp	2013-05-02 16:02:24.000000000 -0400
@@ -13,6 +13,7 @@
 # include <config.h>
 #endif

+#include <glibmm.h>
 #include <glibmm/i18n.h>
 #include <gtkmm/liststore.h>
 #include <gtkmm/treeview.h>
diff -ru inkscape-0.48.4/src/ui/tool/control-point.cpp inkscape-FToU/inkscape-0.48.4/src/ui/tool/control-point.cpp
--- inkscape-0.48.4/src/ui/tool/control-point.cpp	2012-02-13 22:22:17.000000000 -0500
+++ inkscape-FToU/inkscape-0.48.4/src/ui/tool/control-point.cpp	2013-05-02 16:03:07.000000000 -0400
@@ -9,6 +9,7 @@
  */

 #include <iostream>
+#include <glibmm.h>
 #include <gdkmm.h>
 #include <gtkmm.h>
 #include <2geom/point.h>
