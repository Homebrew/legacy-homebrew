class Glade < Formula
  desc "RAD tool for the GTK+ and GNOME environment"
  homepage "https://glade.gnome.org/"
  url "https://download.gnome.org/sources/glade3/3.8/glade3-3.8.5.tar.xz"
  sha256 "58a5f6e4df4028230ddecc74c564808b7ec4471b1925058e29304f778b6b2735"
  revision 1

  bottle do
    sha256 "5c910f1666f6e261369aa166bea2e48e5b03856928900448c2c577ec4f04eca2" => :el_capitan
    sha256 "8f0c1d019b71e76381c0f4437395f1e1eb3da24e8ef1b16051535209aeeaf5d7" => :yosemite
    sha256 "f4eae837311b7aadfff8a27720ce2bbc71871e9b095d31e90d4b833ec725205f" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "libxml2"
  depends_on "hicolor-icon-theme"
  depends_on "gtk+"
  depends_on "gtk-mac-integration"

  # patch restores compatibility with the latest gtk-mac-integration version
  # this bug has been filed: https://bugzilla.gnome.org/show_bug.cgi?id=730778
  patch :DATA

  def install
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make" # separate steps required
    system "make", "install"
  end

  test do
    # executable test (GUI)
    system "#{bin}/glade-3", "--version"
    # API test
    (testpath/"test.c").write <<-EOS.undent
      #include <gladeui/glade.h>

      int main(int argc, char *argv[]) {
        gboolean glade_util_have_devhelp();
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
      -I#{include}/libgladeui-1.0
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
      -lgladeui-1
      -lglib-2.0
      -lgobject-2.0
      -lgtk-quartz-2.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
      -lxml2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
__END__
diff --git a/src/glade-window.c b/src/glade-window.c
index f244c55..d7fb435 100644
--- a/src/glade-window.c
+++ b/src/glade-window.c
@@ -3395,34 +3395,34 @@ glade_window_init (GladeWindow *window)
	{
		/* Fix up the menubar for MacOSX Quartz builds */
		GtkWidget *sep;
-		GtkOSXApplication *theApp = g_object_new(GTK_TYPE_OSX_APPLICATION, NULL);
+		GtkosxApplication *theApp = g_object_new(GTKOSX_TYPE_APPLICATION, NULL);
		gtk_widget_hide (menubar);
-		gtk_osxapplication_set_menu_bar(theApp, GTK_MENU_SHELL(menubar));
+		gtkosx_application_set_menu_bar(theApp, GTK_MENU_SHELL(menubar));
		widget =
			gtk_ui_manager_get_widget (window->priv->ui, "/MenuBar/FileMenu/Quit");
		gtk_widget_hide (widget);
		widget =
			gtk_ui_manager_get_widget (window->priv->ui, "/MenuBar/HelpMenu/About");
-		gtk_osxapplication_insert_app_menu_item (theApp, widget, 0);
+		gtkosx_application_insert_app_menu_item (theApp, widget, 0);
		sep = gtk_separator_menu_item_new();
		g_object_ref(sep);
-		gtk_osxapplication_insert_app_menu_item (theApp, sep, 1);
+		gtkosx_application_insert_app_menu_item (theApp, sep, 1);

		widget =
			gtk_ui_manager_get_widget (window->priv->ui, "/MenuBar/EditMenu/Preferences");
-		gtk_osxapplication_insert_app_menu_item  (theApp, widget, 2);
+		gtkosx_application_insert_app_menu_item  (theApp, widget, 2);
		sep = gtk_separator_menu_item_new();
		g_object_ref(sep);
-		gtk_osxapplication_insert_app_menu_item (theApp, sep, 3);
+		gtkosx_application_insert_app_menu_item (theApp, sep, 3);

		widget =
			gtk_ui_manager_get_widget (window->priv->ui, "/MenuBar/HelpMenu");
-		gtk_osxapplication_set_help_menu(theApp, GTK_MENU_ITEM(widget));
+		gtkosx_application_set_help_menu(theApp, GTK_MENU_ITEM(widget));

		g_signal_connect(theApp, "NSApplicationWillTerminate",
				 G_CALLBACK(quit_cb), window);

-		gtk_osxapplication_ready(theApp);
+		gtkosx_application_ready(theApp);

	}
 #endif
