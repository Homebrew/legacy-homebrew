class Gtkx < Formula
  desc "GUI toolkit"
  homepage "http://gtk.org/"
  url "https://download.gnome.org/sources/gtk+/2.24/gtk+-2.24.28.tar.xz"
  sha256 "b2c6441e98bc5232e5f9bba6965075dcf580a8726398f7374d39f90b88ed4656"
  revision 3

  bottle do
    sha256 "c50b23ea76ad0379e43a44ac2520e2243c5b2f2aded21c7e82c36c20e6a90e1a" => :el_capitan
    sha256 "72a95671b8b9ba6aaf3e8900f4af6bd9b0b0fcdd6621a200838d3e2622bc7a26" => :yosemite
    sha256 "0754d744caed63c14ce80b5c3895679d1b93dad9832ca6105488eefa809bb7c1" => :mavericks
  end

  option "with-quartz-relocation", "Build with quartz relocation support"

  depends_on "pkg-config" => :build
  depends_on "gdk-pixbuf"
  depends_on "jasper" => :optional
  depends_on "atk"
  depends_on "pango"
  depends_on "gobject-introspection"
  depends_on "hicolor-icon-theme"

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  # Patch to allow Freeciv's gtk2 client to run.
  # See:
  # - https://bugzilla.gnome.org/show_bug.cgi?id=557780
  # - Homebrew/homebrew-games#278
  patch do
    url "https://bug557780.bugzilla-attachments.gnome.org/attachment.cgi?id=306776"
    sha256 "4d7a1fe8d55174dc7f0be0016814668098d38bbec233b05a6c46180e96a159fc"
  end

  # Fix crash on OS X 10.11
  # See: https://bugzilla.gnome.org/show_bug.cgi?id=753992
  patch do
    url "https://bug753992.bugzilla-attachments.gnome.org/attachment.cgi?id=312565"
    sha256 "e2e8d5c236d4de7d5b5fd79a2e90861b281746132a3f96aca6ab0cb780926876"
  end

  def install
    args = ["--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}",
            "--disable-glibtest",
            "--enable-introspection=yes",
            "--with-gdktarget=quartz",
            "--disable-visibility"]

    args << "--enable-quartz-relocation" if build.with?("quartz-relocation")

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        GtkWidget *label = gtk_label_new("Hello World!");
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
      -I#{include}/gtk-2.0
      -I#{libpng.opt_include}/libpng16
      -I#{lib}/gtk-2.0/include
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
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
