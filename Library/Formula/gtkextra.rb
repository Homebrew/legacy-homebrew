class Gtkextra < Formula
  desc "Widgets for creating GUIs for GTK+"
  homepage "http://gtkextra.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gtkextra/3.1/gtkextra-3.1.4.tar.gz"
  sha256 "cfc61cf76dbce36bede5cbfd967a2cdea49be869f671a9619c85ce4b4cfb5037"

  bottle do
    cellar :any
    sha256 "344d4928075c709f5bdb0799c6b01b28a5ce16b5b93b41e58bd5c61fb441615f" => :yosemite
    sha256 "cbf7a0b80d1627880b09994c4b8a24a9e3de89d7d77d44d1fbc2cf250fb43221" => :mavericks
    sha256 "14bd7612815970eb2f4f7e9aa69163a1a5958e2b21e627f5f086368bb9acd504" => :mountain_lion
  end

  depends_on "gtk+"
  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-tests",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
    #include <gtkextra/gtkextra.h>
    int main(int argc, char *argv[]) {
      GtkWidget *canvas = gtk_plot_canvas_new(GTK_PLOT_A4_H, GTK_PLOT_A4_W, 0.8);
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
      -I#{include}/gtkextra-3.0
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
      -lgtkextra-quartz-3.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
