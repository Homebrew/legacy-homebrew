class Libgnomecanvas < Formula
  desc "Highlevel, structured graphics library"
  homepage "https://developer.gnome.org/libgnomecanvas/2.30/"
  url "https://download.gnome.org/sources/libgnomecanvas/2.30/libgnomecanvas-2.30.3.tar.bz2"
  sha256 "859b78e08489fce4d5c15c676fec1cd79782f115f516e8ad8bed6abcb8dedd40"
  revision 1

  bottle do
    cellar :any
    sha256 "d92afd4e619d083844ab2eb3f36e8775512fb896c5caa677456c5d527e9d81e6" => :yosemite
    sha256 "3ba01178cdc04412a402b043cc89fc59269573347c704f9c37281a84bf111988" => :mavericks
    sha256 "c3aac3d57c825f6634d07130fb868e5325fd405a0e7583ab28756fca4515508d" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "libglade"
  depends_on "libart"
  depends_on "gettext"
  depends_on "gtk+"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-static",
                          "--prefix=#{prefix}",
                          "--enable-glade"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <libgnomecanvas/libgnomecanvas.h>

      int main(int argc, char *argv[]) {
        GnomeCanvasPoints *gcp = gnome_canvas_points_new(100);
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx = Formula["gtk+"]
    harfbuzz = Formula["harfbuzz"]
    libart = Formula["libart"]
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
      -I#{gtkx.opt_include}/gail-1.0
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/libgnomecanvas-2.0
      -I#{libart.opt_include}/libart-2.0
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
      -L#{libart.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -lart_lgpl_2
      -latk-1.0
      -lcairo
      -lgdk-quartz-2.0
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgnomecanvas-2
      -lgobject-2.0
      -lgtk-quartz-2.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
