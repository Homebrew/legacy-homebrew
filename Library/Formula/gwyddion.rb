class Gwyddion < Formula
  desc "Scanning Probe Microscopy visualization and analysis tool"
  homepage "http://gwyddion.net/"
  url "http://gwyddion.net/download/2.41/gwyddion-2.41.tar.gz"
  sha256 "093e5e20e85cbfc14786a8dcc319943ad30419bffd5ab883e7d0400161fb3cd4"

  bottle do
    sha256 "557467222d7732e7ab0909336e60cf40e865db1802b424716c749c0acd1f3338" => :yosemite
    sha256 "51840b592615b74443d82450486a26834b2b154ff9a34d6e0452c67a3d6b7658" => :mavericks
    sha256 "70333e143e8e5e6845fcc891cecd2123c2aa9b84e74572daf52637fde5857914" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "gtk-mac-integration"
  depends_on "libxml2"
  depends_on "fftw"
  depends_on "gtkglext"
  depends_on :python => :optional
  depends_on "pygtk" if build.with? "python"
  depends_on "gtksourceview" if build.with? "python"

  def install
    # Add Python library path and prevent explicit linkage for the gwy module.
    # Upstream patch: <http://sourceforge.net/p/gwyddion/mailman/message/34347458/>
    inreplace "configure", 'PYTHON_LIBS=-l$libpython',
                           %(py_prefix=`$PYTHON -c "import sys; print sys.prefix"`
                           PYTHON_LIBS="-L${py_prefix}/lib -l$libpython")
    inreplace "modules/pygwy/Makefile.in", '$(PYTHON_LIBS) $(PYGTK_LIBS) @GTK_LIBS@',
                                           '-undefined dynamic_lookup $(PYGTK_LIBS) @GTK_LIBS@'

    system "./configure", "--disable-dependency-tracking",
                          "--disable-desktop-file-update",
                          "--prefix=#{prefix}",
                          "--with-html-dir=#{doc}"
    system "make", "install"
  end

  test do
    system "#{bin}/gwyddion", "--version"
    (testpath/"test.c").write <<-EOS.undent
      #include <libgwyddion/gwyddion.h>

      int main(int argc, char *argv[]) {
        const gchar *string = gwy_version_string();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fftw = Formula["fftw"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx = Formula["gtk+"]
    gtkglext = Formula["gtkglext"]
    harfbuzz = Formula["harfbuzz"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fftw.opt_include}
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkglext.opt_include}/gtkglext-1.0
      -I#{gtkglext.opt_lib}/gtkglext-1.0/include
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/gwyddion
      -I#{libpng.opt_include}/libpng16
      -I#{lib}/gwyddion/include
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{fftw.opt_lib}
      -L#{fontconfig.opt_lib}
      -L#{freetype.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkglext.opt_lib}
      -L#{gtkx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lfftw3
      -lfontconfig
      -lfreetype
      -lgdk-quartz-2.0
      -lgdk_pixbuf-2.0
      -lgdkglext-quartz-1.0
      -lgio-2.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lgtk-quartz-2.0
      -lgtkglext-quartz-1.0
      -lgwyapp2
      -lgwyddion2
      -lgwydgets2
      -lgwydraw2
      -lgwymodule2
      -lgwyprocess2
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
      -lpangoft2-1.0
      -framework AppKit
      -framework OpenGL
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
