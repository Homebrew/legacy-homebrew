class Gtksourceview < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/2.10/gtksourceview-2.10.5.tar.gz"
  sha256 "f5c3dda83d69c8746da78c1434585169dd8de1eecf2a6bcdda0d9925bf857c97"
  revision 1

  bottle do
    revision 1
    sha256 "bb2a0ea508b1e7bbb951a88d964118fd35a366876c99a7f0c9dc8e2e70642e2f" => :el_capitan
    sha256 "e2fa037441adb54ad813c63d65093020c79650dca171288aa6863699bc3ce4fc" => :yosemite
    sha256 "ddc07f644281392d25ce7353b43e44bf55fbf2187f5b49d1a08ce84a428e4170" => :mavericks
    sha256 "fb00bdc4c2761ed7bdb838bbdf919eb61961aec7d77092047ead0e72e1e0e472" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gtk+"
  depends_on "gtk-mac-integration"

  # patches added the ensure that gtk-mac-integration is supported properly instead
  # of the old released called ige-mac-integration.
  # These are already integrated upstream in their gnome-2-30 branch but a release of
  # this remains highly unlikely
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gtksourceview/gtksourceview.h>

      int main(int argc, char *argv[]) {
        GtkWidget *widget = gtk_source_view_new();
        return 0;
      }
    EOS
    ENV.libxml2
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx = Formula["gtk+"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{include}/gtksourceview-2.0
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lgdk-quartz-2.0
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-quartz-2.0
      -lgtksourceview-2.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
__END__
diff --git a/configure b/configure
index ed522e5..5f51d4f 100755
--- a/configure
+++ b/configure
@@ -11220,12 +11220,12 @@ if test -n "$IGE_MAC_CFLAGS"; then
     pkg_cv_IGE_MAC_CFLAGS="$IGE_MAC_CFLAGS"
  elif test -n "$PKG_CONFIG"; then
     if test -n "$PKG_CONFIG" && \
-    { { $as_echo "$as_me:${as_lineno-$LINENO}: \$PKG_CONFIG --exists --print-errors \"ige-mac-integration\""; } >&5
-  ($PKG_CONFIG --exists --print-errors "ige-mac-integration") 2>&5
+    { { $as_echo "$as_me:${as_lineno-$LINENO}: \$PKG_CONFIG --exists --print-errors \"gtk-mac-integration-gtk2\""; } >&5
+  ($PKG_CONFIG --exists --print-errors "gtk-mac-integration-gtk2") 2>&5
   ac_status=$?
   $as_echo "$as_me:${as_lineno-$LINENO}: \$? = $ac_status" >&5
   test $ac_status = 0; }; then
-  pkg_cv_IGE_MAC_CFLAGS=`$PKG_CONFIG --cflags "ige-mac-integration" 2>/dev/null`
+  pkg_cv_IGE_MAC_CFLAGS=`$PKG_CONFIG --cflags "gtk-mac-integration-gtk2" 2>/dev/null`
 else
   pkg_failed=yes
 fi
@@ -11236,12 +11236,12 @@ if test -n "$IGE_MAC_LIBS"; then
     pkg_cv_IGE_MAC_LIBS="$IGE_MAC_LIBS"
  elif test -n "$PKG_CONFIG"; then
     if test -n "$PKG_CONFIG" && \
-    { { $as_echo "$as_me:${as_lineno-$LINENO}: \$PKG_CONFIG --exists --print-errors \"ige-mac-integration\""; } >&5
-  ($PKG_CONFIG --exists --print-errors "ige-mac-integration") 2>&5
+    { { $as_echo "$as_me:${as_lineno-$LINENO}: \$PKG_CONFIG --exists --print-errors \"gtk-mac-integration-gtk2\""; } >&5
+  ($PKG_CONFIG --exists --print-errors "gtk-mac-integration-gtk2") 2>&5
   ac_status=$?
   $as_echo "$as_me:${as_lineno-$LINENO}: \$? = $ac_status" >&5
   test $ac_status = 0; }; then
-  pkg_cv_IGE_MAC_LIBS=`$PKG_CONFIG --libs "ige-mac-integration" 2>/dev/null`
+  pkg_cv_IGE_MAC_LIBS=`$PKG_CONFIG --libs "gtk-mac-integration-gtk2" 2>/dev/null`
 else
   pkg_failed=yes
 fi
@@ -11261,14 +11261,14 @@ else
         _pkg_short_errors_supported=no
 fi
         if test $_pkg_short_errors_supported = yes; then
-	        IGE_MAC_PKG_ERRORS=`$PKG_CONFIG --short-errors --print-errors "ige-mac-integration" 2>&1`
+	        IGE_MAC_PKG_ERRORS=`$PKG_CONFIG --short-errors --print-errors "gtk-mac-integration-gtk2" 2>&1`
         else
-	        IGE_MAC_PKG_ERRORS=`$PKG_CONFIG --print-errors "ige-mac-integration" 2>&1`
+	        IGE_MAC_PKG_ERRORS=`$PKG_CONFIG --print-errors "gtk-mac-integration-gtk2" 2>&1`
         fi
	# Put the nasty error message in config.log where it belongs
	echo "$IGE_MAC_PKG_ERRORS" >&5

-	as_fn_error $? "Package requirements (ige-mac-integration) were not met:
+	as_fn_error $? "Package requirements (gtk-mac-integration-gtk2) were not met:

 $IGE_MAC_PKG_ERRORS

diff --git a/gtksourceview/gtksourceview-i18n.c b/gtksourceview/gtksourceview-i18n.c
index e4db3eb..70f8f2c 100644
--- a/gtksourceview/gtksourceview-i18n.c
+++ b/gtksourceview/gtksourceview-i18n.c
@@ -24,7 +24,7 @@
 #endif

 #ifdef OS_OSX
-#include <ige-mac-bundle.h>
+#include <gtkosxapplication.h>
 #endif

 #include <string.h>
@@ -45,12 +45,10 @@ get_locale_dir (void)

	g_free (win32_dir);
 #elif defined (OS_OSX)
-	IgeMacBundle *bundle = ige_mac_bundle_get_default ();
-
-	if (ige_mac_bundle_get_is_app_bundle (bundle))
-	{
-		locale_dir = g_strdup (ige_mac_bundle_get_localedir (bundle));
-	}
+        if(gtkosx_application_get_bundle_id () != NULL)
+ 	{
+ 		locale_dir = g_strdup (gtkosx_application_get_resource_path ());
+ 	}
	else
	{
		locale_dir = g_build_filename (DATADIR, "locale", NULL);
