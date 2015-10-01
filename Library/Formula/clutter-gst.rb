class ClutterGst < Formula
  desc "ClutterMedia interface using GStreamer for video and audio"
  homepage "https://developer.gnome.org/clutter-gst/"
  url "https://download.gnome.org/sources/clutter-gst/3.0/clutter-gst-3.0.12.tar.xz"
  sha256 "cd2b2f8db9c21d6295ed0b2811d4c3036fac5796be71d7affdb2b8746f12066c"

  bottle do
    revision 1
    sha256 "93044b081e811fda6cfef3450fda71fef0253fa90c2125dbce1de1839ceae061" => :el_capitan
    sha256 "1728ff5dc8fcd9bd2041b332ec179e16b72046a0da772d34a224de527fe7e67d" => :yosemite
    sha256 "d2b0f46bcf88ad8ff13594973d2c2d55ee929bc27fe331882f0eb84cc718c992" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "clutter"
  depends_on "gstreamer"
  depends_on "gst-plugins-base"
  depends_on "gdk-pixbuf"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --prefix=#{prefix}
      --enable-introspection=yes
      --disable-silent-rules
      --disable-gtk-doc-html
    ]

    # the source code requires gdk-pixbuf but configure doesn't look for it
    ENV.append "CFLAGS", `pkg-config --cflags gdk-pixbuf-2.0`.chomp
    ENV.append "LIBS", `pkg-config --libs gdk-pixbuf-2.0`.chomp

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <clutter-gst/clutter-gst.h>

      int main(int argc, char *argv[]) {
        clutter_gst_init(&argc, &argv);
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    clutter = Formula["clutter"]
    cogl = Formula["cogl"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gst_plugins_base = Formula["gst-plugins-base"]
    gstreamer = Formula["gstreamer"]
    json_glib = Formula["json-glib"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{clutter.opt_include}/clutter-1.0
      -I#{cogl.opt_include}/cogl
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gst_plugins_base.opt_include}/gstreamer-1.0
      -I#{gstreamer.opt_include}/gstreamer-1.0
      -I#{gstreamer.opt_lib}/gstreamer-1.0/include
      -I#{include}/clutter-gst-3.0
      -I#{json_glib.opt_include}/json-glib-1.0
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{clutter.opt_lib}
      -L#{cogl.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gst_plugins_base.opt_lib}
      -L#{gstreamer.opt_lib}
      -L#{json_glib.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lclutter-1.0
      -lclutter-gst-3.0
      -lcogl
      -lcogl-pango
      -lcogl-path
      -lgio-2.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lgstbase-1.0
      -lgstreamer-1.0
      -lgstvideo-1.0
      -lintl
      -ljson-glib-1.0
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
