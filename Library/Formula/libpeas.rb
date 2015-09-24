class Libpeas < Formula
  desc "GObject plugin library"
  homepage "https://developer.gnome.org/libpeas/stable/"
  url "https://download.gnome.org/sources/libpeas/1.14/libpeas-1.14.0.tar.xz"
  sha256 "5e4b3a8968b71497ab26a7a528c414c4c640c5724328fa3507854f04788e2d76"

  bottle do
    sha256 "6959622982b81ce241a372f6911563987b3b5169c27afb46539e18460b4591fd" => :el_capitan
    sha256 "3d96adbac4014c293339b23d96447ef56246c9986ec7d6c198aef3b0394fef08" => :yosemite
    sha256 "6cf87185dd7d908ff8207d4ca77227cdbc3f40183c3aedcd6722f6f36f868dcb" => :mavericks
    sha256 "2fac61c95a159f52ecb1e3ec07d8765612a45ed743647dd35c529fd87b82eae7" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gnome-common" => :build
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk+3"

  # fixes a linking issue in the tests
  # submitted upsteam as a PR: https://github.com/gregier/libpeas/pull/3
  patch :DATA

  def install
    system "autoreconf", "-i"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-gtk"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <libpeas/peas.h>

      int main(int argc, char *argv[]) {
        PeasObjectModule *mod = peas_object_module_new("test", "test", FALSE);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gobject_introspection = Formula["gobject-introspection"]
    libffi = Formula["libffi"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gobject_introspection.opt_include}/gobject-introspection-1.0
      -I#{include}/libpeas-1.0
      -I#{libffi.opt_lib}/libffi-3.0.13/include
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gobject_introspection.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lgirepository-1.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lintl
      -lpeas-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/tests/libpeas/plugins/extension-c/Makefile.am b/tests/libpeas/plugins/extension-c/Makefile.am
index 9f18008..ed51b06 100644
--- a/tests/libpeas/plugins/extension-c/Makefile.am
+++ b/tests/libpeas/plugins/extension-c/Makefile.am
@@ -18,7 +18,8 @@ libextension_c_la_SOURCES = \
 libextension_c_la_LDFLAGS = $(TEST_PLUGIN_LIBTOOL_FLAGS)
 libextension_c_la_LIBADD = \
	$(PEAS_LIBS)						\
-	$(builddir)/../../introspection/libintrospection-1.0.la
+	$(builddir)/../../introspection/libintrospection-1.0.la \
+	$(top_builddir)/libpeas/libpeas-1.0.la

 libextension_c_missing_symbol_la_SOURCES = \
	extension-c-missing-symbol-plugin.c
