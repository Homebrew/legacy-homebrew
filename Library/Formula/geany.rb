class Geany < Formula
  desc "Basic text editor with IDE support"
  homepage "http://geany.org/"
  url "http://download.geany.org/geany-1.26.tar.bz2"
  sha256 "e38530e87c577e1e9806be3b40e08fb9ee321eb1abc6361ddacdad89c825f90d"

  bottle do
    sha256 "586a86aec5d83a673094ad0334a33e8c85d4bf78f18370e1876f7f6617f909b8" => :el_capitan
    sha256 "62288c061ab23039b4baabd2fd1420b790d38be577e19f9e838d9e4be7960098" => :yosemite
    sha256 "9d8ee1a345107f4b8b3d594350fd671737b134f12d95136b0bfe9c0e8024ec4a" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gtk+"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # main executable test (GUI)
    system "#{bin}/geany", "--version"
    # API test
    (testpath/"test.c").write <<-EOS.undent
      #include <geanyplugin.h>
      PLUGIN_SET_INFO("HelloWorld", "Just another tool to say hello world", "1.0", "Joe Doe <joe.doe@example.org>");
      int main(int argc, char *argv[]) {
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
      -I#{include}/geany
      -I#{include}/geany/scintilla
      -I#{include}/geany/tagmanager
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -DGTK
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
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
