class Libgnomecanvasmm < Formula
  desc "C++ wrapper for libgnomecanvas"
  homepage "https://launchpad.net/libgnomecanvasmm"
  url "https://download.gnome.org/sources/libgnomecanvasmm/2.26/libgnomecanvasmm-2.26.0.tar.bz2"
  sha256 "996577f97f459a574919e15ba7fee6af8cda38a87a98289e9a4f54752d83e918"
  revision 2

  bottle do
    cellar :any
    sha256 "0f0e6854e6fc0c24e55e8983b2f8bb0f8c272b4c4cc86d20b70a79ceb8bc3fb0" => :el_capitan
    sha256 "34c1f6021fbfbacf98c46313bcf4b5581e49dda7886c7c208ef9bf9f71b22d30" => :yosemite
    sha256 "ca4427db512b6049c304cf70a30e3664af4b80780eb7836c20ff4c22695ab102" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libgnomecanvas"
  depends_on "gtkmm"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libgnomecanvasmm.h>

      int main(int argc, char *argv[]) {
        Gnome::Canvas::init();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    atkmm = Formula["atkmm"]
    cairo = Formula["cairo"]
    cairomm = Formula["cairomm"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    glibmm = Formula["glibmm"]
    gtkx = Formula["gtk+"]
    gtkmm = Formula["gtkmm"]
    harfbuzz = Formula["harfbuzz"]
    libart = Formula["libart"]
    libgnomecanvas = Formula["libgnomecanvas"]
    libpng = Formula["libpng"]
    libsigcxx = Formula["libsigc++"]
    pango = Formula["pango"]
    pangomm = Formula["pangomm"]
    pixman = Formula["pixman"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{atkmm.opt_include}/atkmm-1.6
      -I#{cairo.opt_include}/cairo
      -I#{cairomm.opt_include}/cairomm-1.0
      -I#{cairomm.opt_lib}/cairomm-1.0/include
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/giomm-2.4
      -I#{glibmm.opt_include}/glibmm-2.4
      -I#{glibmm.opt_lib}/giomm-2.4/include
      -I#{glibmm.opt_lib}/glibmm-2.4/include
      -I#{gtkmm.opt_include}/gdkmm-2.4
      -I#{gtkmm.opt_include}/gtkmm-2.4
      -I#{gtkmm.opt_lib}/gdkmm-2.4/include
      -I#{gtkmm.opt_lib}/gtkmm-2.4/include
      -I#{gtkx.opt_include}/gail-1.0
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_include}/gtk-unix-print-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/libgnomecanvasmm-2.6
      -I#{libart.opt_include}/libart-2.0
      -I#{libgnomecanvas.opt_include}/libgnomecanvas-2.0
      -I#{libpng.opt_include}/libpng16
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/libgnomecanvasmm-2.6/include
      -I#{pango.opt_include}/pango-1.0
      -I#{pangomm.opt_include}/pangomm-1.4
      -I#{pangomm.opt_lib}/pangomm-1.4/include
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{atkmm.opt_lib}
      -L#{cairo.opt_lib}
      -L#{cairomm.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{glibmm.opt_lib}
      -L#{gtkmm.opt_lib}
      -L#{gtkx.opt_lib}
      -L#{libart.opt_lib}
      -L#{libgnomecanvas.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -L#{pangomm.opt_lib}
      -lart_lgpl_2
      -latk-1.0
      -latkmm-1.6
      -lcairo
      -lcairomm-1.0
      -lgdk-quartz-2.0
      -lgdk_pixbuf-2.0
      -lgdkmm-2.4
      -lgio-2.0
      -lgiomm-2.4
      -lglib-2.0
      -lglibmm-2.4
      -lgnomecanvas-2
      -lgnomecanvasmm-2.6
      -lgobject-2.0
      -lgtk-quartz-2.0
      -lgtkmm-2.4
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
      -lpangomm-1.4
      -lsigc-2.0
    ]
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
