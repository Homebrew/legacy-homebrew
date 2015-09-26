class Gedit < Formula
  desc "The GNOME text editor"
  homepage "https://wiki.gnome.org/Apps/Gedit"
  url "https://download.gnome.org/sources/gedit/3.16/gedit-3.16.3.tar.xz"
  sha256 "c28df44a29ee5707441f89e94b513079d709111afec4bd4b079a1dff0242cdb2"

  bottle do
    sha256 "a181e2b41c720e0022adfe06a4125fac8e02f4dc096c180d82f65de6049b4ec1" => :el_capitan
    sha256 "6893d02c163913dacba65545073d6409854d919df3f7e3ceea74caf770553a24" => :yosemite
    sha256 "4ac212b887b604a2bc90f5d8eb9211af32f5adfd181e80c78425c01718aa27b6" => :mavericks
    sha256 "7c9848922d9d98ffb0583c8389e2e4ce6ba1753c3fbebd5e15ea6cee2953e255" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "gtk+3"
  depends_on "gtk-mac-integration"
  depends_on "gobject-introspection"
  depends_on "enchant"
  depends_on "iso-codes"
  depends_on "libxml2"
  depends_on "libpeas"
  depends_on "gtksourceview3"
  depends_on "gsettings-desktop-schemas"
  depends_on "gnome-icon-theme"

  # ensures that gtk-mac-integration has been linked against gtk+3
  # filed upstream as https://bugzilla.gnome.org/show_bug.cgi?id=751431
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-updater",
                          "--disable-schemas-compile",
                          "--disable-python"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    # main executable test
    system "gedit", "--version"
    # API test
    (testpath/"test.c").write <<-EOS.undent
      #include <gedit/gedit-utils.h>

      int main(int argc, char *argv[]) {
        gchar *text = gedit_utils_make_valid_utf8("test text");
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
    gobject_introspection = Formula["gobject-introspection"]
    gtkx3 = Formula["gtk+3"]
    gtksourceview3 = Formula["gtksourceview3"]
    libepoxy = Formula["libepoxy"]
    libffi = Formula["libffi"]
    libpeas = Formula["libpeas"]
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
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gobject_introspection.opt_include}/gobject-introspection-1.0
      -I#{gtksourceview3.opt_include}/gtksourceview-3.0
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{include}/gedit-3.14
      -I#{libepoxy.opt_include}
      -I#{libffi.opt_lib}/libffi-3.0.13/include
      -I#{libpeas.opt_include}/libpeas-1.0
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{lib}/gedit
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gobject_introspection.opt_lib}
      -L#{gtksourceview3.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{libpeas.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgedit
      -lgio-2.0
      -lgirepository-1.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lgtk-3
      -lgtksourceview-3.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
      -lpeas-1.0
      -lpeas-gtk-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/configure b/configure
index 2a16d57..9ad2e56 100755
--- a/configure
+++ b/configure
@@ -13107,12 +13107,12 @@ if test -n "$GTK_MAC_CFLAGS"; then
     pkg_cv_GTK_MAC_CFLAGS="$GTK_MAC_CFLAGS"
  elif test -n "$PKG_CONFIG"; then
     if test -n "$PKG_CONFIG" && \
-    { { $as_echo "$as_me:${as_lineno-$LINENO}: \$PKG_CONFIG --exists --print-errors \"gtk-mac-integration\""; } >&5
-  ($PKG_CONFIG --exists --print-errors "gtk-mac-integration") 2>&5
+    { { $as_echo "$as_me:${as_lineno-$LINENO}: \$PKG_CONFIG --exists --print-errors \"gtk-mac-integration-gtk3\""; } >&5
+  ($PKG_CONFIG --exists --print-errors "gtk-mac-integration-gtk3") 2>&5
   ac_status=$?
   $as_echo "$as_me:${as_lineno-$LINENO}: \$? = $ac_status" >&5
   test $ac_status = 0; }; then
-  pkg_cv_GTK_MAC_CFLAGS=`$PKG_CONFIG --cflags "gtk-mac-integration" 2>/dev/null`
+  pkg_cv_GTK_MAC_CFLAGS=`$PKG_CONFIG --cflags "gtk-mac-integration-gtk3" 2>/dev/null`
		      test "x$?" != "x0" && pkg_failed=yes
 else
   pkg_failed=yes
@@ -13124,12 +13124,12 @@ if test -n "$GTK_MAC_LIBS"; then
     pkg_cv_GTK_MAC_LIBS="$GTK_MAC_LIBS"
  elif test -n "$PKG_CONFIG"; then
     if test -n "$PKG_CONFIG" && \
-    { { $as_echo "$as_me:${as_lineno-$LINENO}: \$PKG_CONFIG --exists --print-errors \"gtk-mac-integration\""; } >&5
-  ($PKG_CONFIG --exists --print-errors "gtk-mac-integration") 2>&5
+    { { $as_echo "$as_me:${as_lineno-$LINENO}: \$PKG_CONFIG --exists --print-errors \"gtk-mac-integrationi-gtk3\""; } >&5
+  ($PKG_CONFIG --exists --print-errors "gtk-mac-integration-gtk3") 2>&5
   ac_status=$?
   $as_echo "$as_me:${as_lineno-$LINENO}: \$? = $ac_status" >&5
   test $ac_status = 0; }; then
-  pkg_cv_GTK_MAC_LIBS=`$PKG_CONFIG --libs "gtk-mac-integration" 2>/dev/null`
+  pkg_cv_GTK_MAC_LIBS=`$PKG_CONFIG --libs "gtk-mac-integration-gtk3" 2>/dev/null`
		      test "x$?" != "x0" && pkg_failed=yes
 else
   pkg_failed=yes
@@ -13150,14 +13150,14 @@ else
         _pkg_short_errors_supported=no
 fi
         if test $_pkg_short_errors_supported = yes; then
-	        GTK_MAC_PKG_ERRORS=`$PKG_CONFIG --short-errors --print-errors --cflags --libs "gtk-mac-integration" 2>&1`
+	        GTK_MAC_PKG_ERRORS=`$PKG_CONFIG --short-errors --print-errors --cflags --libs "gtk-mac-integration-gtk3" 2>&1`
         else
-	        GTK_MAC_PKG_ERRORS=`$PKG_CONFIG --print-errors --cflags --libs "gtk-mac-integration" 2>&1`
+	        GTK_MAC_PKG_ERRORS=`$PKG_CONFIG --print-errors --cflags --libs "gtk-mac-integration-gtk3" 2>&1`
         fi
	# Put the nasty error message in config.log where it belongs
	echo "$GTK_MAC_PKG_ERRORS" >&5

-	as_fn_error $? "Package requirements (gtk-mac-integration) were not met:
+	as_fn_error $? "Package requirements (gtk-mac-integration-gtk3) were not met:

 $GTK_MAC_PKG_ERRORS
