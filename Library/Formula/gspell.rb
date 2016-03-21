class Gspell < Formula
  desc "Flexible API to implement spellchecking in GTK+ applications"
  homepage "https://wiki.gnome.org/Projects/gspell"
  url "https://download.gnome.org/sources/gspell/1.0/gspell-1.0.0.tar.xz"
  sha256 "6a50257c871c318445881c115bdd11bb8da6672f7d5b99e96c2e7b5c00f077da"

  bottle do
    sha256 "c6633e8f395f042c59dfe19841413261a3735f8ce7eba52b6aac48c542ea01ed" => :el_capitan
    sha256 "84f887139c54fafe37e41324a8573ee986ad053cc03bed3fa26f89e4951a8443" => :yosemite
    sha256 "69443dbcf313c29058029163bfaa9fa1c2f10cf803ed7f1675919b063a765bb7" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "enchant"
  depends_on "gtk+3"
  depends_on "gtk-mac-integration"
  depends_on "iso-codes"
  depends_on "vala" => :recommended

  # ensures compilation on Mac OS X
  # submitted upstream as https://bugzilla.gnome.org/show_bug.cgi?id=759704
  patch :DATA

  def install
    system "autoreconf", "-i"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gspell/gspell.h>

      int main(int argc, char *argv[]) {
        const GList *list = gspell_language_get_available();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    enchant = Formula["enchant"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx3 = Formula["gtk+3"]
    gtk_mac_integration = Formula["gtk-mac-integration"]
    harfbuzz = Formula["harfbuzz"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{enchant.opt_include}/enchant
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtk_mac_integration.opt_include}/gtkmacintegration
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/gspell-1
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -DMAC_INTEGRATION
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgspell-1
      -lgtk-3
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/gspell/Makefile.am b/gspell/Makefile.am
index f025b4d..13c9743 100644
--- a/gspell/Makefile.am
+++ b/gspell/Makefile.am
@@ -11,7 +11,8 @@ AM_CPPFLAGS =				\
 	$(WARN_CFLAGS)			\
 	$(CODE_COVERAGE_CPPFLAGS)	\
 	$(DEP_CFLAGS)			\
-	$(GTK_MAC_CFLAGS)
+	$(GTK_MAC_CFLAGS)               \
+	-xobjective-c
 
 BUILT_SOURCES =			\
 	gspell-resources.c
@@ -75,7 +76,13 @@ libgspell_core_la_CFLAGS = \
 libgspell_core_la_LDFLAGS =		\
 	-no-undefined			\
 	$(WARN_LDFLAGS)			\
-	$(CODE_COVERAGE_LDFLAGS)
+	$(CODE_COVERAGE_LDFLAGS)        \
+	-framework Cocoa -framework Foundation -framework Cocoa
+
+
+libgspell_core_la_LIBADD =		\
+	$(GTK_MAC_LIBS)
+
 
 # The real library.
 lib_LTLIBRARIES = libgspell-@GSPELL_API_VERSION@.la
@@ -95,7 +102,8 @@ libgspell_@GSPELL_API_VERSION@_la_LDFLAGS =	\
 	-no-undefined				\
 	-export-symbols-regex "^gspell_.*"	\
 	$(WARN_LDFLAGS)				\
-	$(CODE_COVERAGE_LDFLAGS)
+	$(CODE_COVERAGE_LDFLAGS)                \
+	-framework Cocoa -framework Foundation -framework Cocoa
 
 libgspell_includedir = $(includedir)/gspell-@GSPELL_API_VERSION@/gspell
 libgspell_include_HEADERS = $(gspell_public_headers)
@@ -108,7 +116,7 @@ CLEANFILES = $(BUILT_SOURCES)
 
 if OS_OSX
 libgspell_@GSPELL_API_VERSION@_la_LDFLAGS += \
-	-framework Cocoa
+	-framework Cocoa -framework Foundation -framework Cocoa
 
 libgspell_@GSPELL_API_VERSION@_la_CFLAGS += \
 	-xobjective-c

