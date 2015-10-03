class Libglademm < Formula
  desc "C++ wrapper around libglade"
  homepage "https://gnome.org"
  url "https://download.gnome.org/sources/libglademm/2.6/libglademm-2.6.7.tar.bz2"
  sha256 "38543c15acf727434341cc08c2b003d24f36abc22380937707fc2c5c687a2bc3"
  revision 2

  bottle do
    cellar :any
    sha256 "0d0d09182101ac8f2dac48163073bf70998d04741ee156137605eedc91f65361" => :el_capitan
    sha256 "a9f54db752f73d96c4332e7794ba770a222b5bcb1a70b654630886851ed07247" => :yosemite
    sha256 "71ea08cf3a79daf7ecdc5ee7437d66288e3f4851808e04f64b3739fccac4d86a" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gtkmm"
  depends_on "libglade"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libglademm.h>

      int main(int argc, char *argv[]) {
        try {
          throw Gnome::Glade::XmlError("this formula should die");
        }
        catch (Gnome::Glade::XmlError &e) {}
        return 0;
      }
    EOS
    ENV.libxml2
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
    libglade = Formula["libglade"]
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
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_include}/gtk-unix-print-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{include}/libglademm-2.4
      -I#{libglade.opt_include}/libglade-2.0
      -I#{libpng.opt_include}/libpng16
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/libglademm-2.4/include
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
      -L#{libglade.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -L#{pangomm.opt_lib}
      -latk-1.0
      -latkmm-1.6
      -lcairo
      -lcairomm-1.0
      -lgdk-quartz-2.0
      -lgdk_pixbuf-2.0
      -lgdkmm-2.4
      -lgio-2.0
      -lgiomm-2.4
      -lglade-2.0
      -lglademm-2.4
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lgtk-quartz-2.0
      -lgtkmm-2.4
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
      -lpangomm-1.4
      -lsigc-2.0
      -lxml2
    ]
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
