class Gom < Formula
  desc "GObject wrapper around SQLite"
  homepage "https://wiki.gnome.org/Projects/Gom"
  url "https://download.gnome.org/sources/gom/0.3/gom-0.3.1.tar.xz"
  sha256 "7951eb46ee784cbdbee6e3f2da084ffbf776c11ca1c904404b05feafe37e38f5"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build

  # the following four lines should be removed when the patch is included in a subsequent release
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gnome-common" => :build

  depends_on "glib"
  depends_on "gobject-introspection"

  # fixes unnecessary hard dependency on gdk-pixbuf
  # patch submitted upstream: https://bugzilla.gnome.org/show_bug.cgi?id=754694
  patch :DATA

  def install
    # the following line should be removed when the patch is included in a subsequent release
    system "autoreconf"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gom/gom.h>

      int main(int argc, char *argv[]) {
        GType type = gom_error_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gom-1.0
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lgobject-2.0
      -lgom-1.0
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/tests/Makefile.include b/tests/Makefile.include
index 28b6c4c..3b56ef8 100644
--- a/tests/Makefile.include
+++ b/tests/Makefile.include
@@ -1,3 +1,5 @@
+if ENABLE_GLIB_TEST
+
 noinst_PROGRAMS =
 noinst_PROGRAMS += test-gom-adapter
 noinst_PROGRAMS += test-gom-repository
@@ -61,4 +63,6 @@ test_gom_update_SOURCES = tests/test-gom-update.c
 test_gom_update_CPPFLAGS = $(GIO_CFLAGS) $(GOBJECT_CFLAGS) $(WARN_CFLAGS)
 test_gom_update_LDADD = $(GIO_LIBS) $(GOBJECT_LIBS) $(top_builddir)/libgom-1.0.la

+endif
+
 EXTRA_DIST += tests/grl-bookmarks.db tests/gnome.png
