class Clutter < Formula
  desc "Generic high-level canvas library"
  homepage "https://wiki.gnome.org/Projects/Clutter"
  url "https://download.gnome.org/sources/clutter/1.22/clutter-1.22.4.tar.xz"
  sha256 "1d77ce16025f87667a1d00dc4fa617a1935156f63fd17635fdadf138866c9e1e"

  bottle do
    sha256 "34f56ac7eceb88057cad0742a8055951885a6eab38e36fde3af5b54311c3fd48" => :yosemite
    sha256 "0d9cb416bc29d59dd542a3760fc14d2f3d8fdf6ab5531102b0835378ad3a0457" => :mavericks
    sha256 "f3068a73eda6b6df486c5658288567dec0d987de74c522412a0879e352d5dd1a" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gdk-pixbuf"
  depends_on "cogl"
  depends_on "cairo" # for cairo-gobject
  depends_on "atk"
  depends_on "pango"
  depends_on "json-glib"
  depends_on "gobject-introspection"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --prefix=#{prefix}
      --enable-introspection=yes
      --disable-silent-rules
      --disable-Bsymbolic
      --disable-examples
      --disable-gtk-doc-html
      --enable-gdk-pixbuf=yes
      --without-x --enable-x11-backend=no
      --enable-quartz-backend=yes
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <clutter/clutter.h>

      int main(int argc, char *argv[]) {
        GOptionGroup *group = clutter_get_option_group_without_init();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    cogl = Formula["cogl"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    json_glib = Formula["json-glib"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{cogl.opt_include}/cogl
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/clutter-1.0
      -I#{json_glib.opt_include}/json-glib-1.0
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{cogl.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{json_glib.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lclutter-1.0
      -lcogl
      -lcogl-pango
      -lcogl-path
      -lgio-2.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lintl
      -ljson-glib-1.0
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
