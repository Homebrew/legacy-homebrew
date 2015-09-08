class GeocodeGlib < Formula
  desc "GNOME library for gecoding and reverse geocoding"
  homepage "https://developer.gnome.org/geocode-glib"
  url "https://download.gnome.org/sources/geocode-glib/3.16/geocode-glib-3.16.2.tar.xz"
  sha256 "a551ffdbd793d54a14e709c9d02e82dde3abc14eed8065abad92275a43fe2c97"

  bottle do
    sha256 "3830373806212fb96930c17c016c7e358b6109a3a4239bac3eb04c2b3c4742ca" => :yosemite
    sha256 "157a923195ede1aa0548660e6a98b9d2123f99764d2aa591d51099eeeb2b23cb" => :mavericks
    sha256 "7955d0be49e8ad30b5abe9c3eab9e731392df51ce2fee30a5962e2963f725f4e" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "libsoup"
  depends_on "gobject-introspection"

  # patch submitted upstream: https://bugzilla.gnome.org/show_bug.cgi?id=754670
  patch :DATA

  def install
    # forces use of gtk3-update-icon-cache instead of gtk-update-icon-cache. No bugreport should
    # be filed for this since it only occurs because Homebrew renames gtk+3's gtk-update-icon-cache
    # to gtk3-update-icon-cache in order to avoid a collision between gtk+ and gtk+3.
    inreplace "icons/Makefile.in", "gtk-update-icon-cache", "gtk3-update-icon-cache"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    # delete icon cache file -> create it post_install
    rm share/"icons/gnome/icon-theme.cache"
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/gnome"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <geocode-glib/geocode-glib.h>

      int main(int argc, char *argv[]) {
        GeocodeLocation *loc = geocode_location_new(1.0, 1.0, 1.0);
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
      -I#{include}/geocode-glib-1.0
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgeocode-glib
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/geocode-glib/geocode-glib.symbols b/geocode-glib/geocode-glib.symbols
index e8550e5..826c9ef 100644
--- a/geocode-glib/geocode-glib.symbols
+++ b/geocode-glib/geocode-glib.symbols
@@ -34,7 +34,6 @@ geocode_reverse_resolve
 geocode_error_quark
 geocode_error_get_type
 _geocode_parse_search_json
-_geocode_parse_resolve_json
 _geocode_read_nominatim_attributes
 _geocode_create_place_from_attributes
 geocode_place_get_type
