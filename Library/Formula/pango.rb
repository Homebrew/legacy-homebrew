class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "http://www.pango.org/"

  stable do
    url "https://download.gnome.org/sources/pango/1.38/pango-1.38.0.tar.xz"
    sha256 "1d4e75974bad853ee9ac5fc5caee5e7ab235abbd945d51d01f3806e04e7c226c"
  end

  bottle do
    sha256 "35609b5fd72070c55965ff9ed2a2221e885c0c9901aa37005a92b223cc96d3b6" => :el_capitan
    sha256 "4c45bd9bda3be814c8b89673360bc90ab444741023c980e8744fe218d94562ba" => :yosemite
    sha256 "61049900a101f9dc393bb825a3a00378f57e925f55b904abcd5537f3c8c130f0" => :mavericks
  end

  head do
    url "https://git.gnome.org/browse/pango.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "gtk-doc" => :build
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "cairo"
  depends_on "harfbuzz"
  depends_on "fontconfig"
  depends_on "gobject-introspection"

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-man
      --with-html-dir=#{share}/doc
      --enable-introspection=yes
      --without-xft
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/pango-view", "--version"
    (testpath/"test.c").write <<-EOS.undent
      #include <pango/pangocairo.h>

      int main(int argc, char *argv[]) {
        PangoFontMap *fontmap;
        int n_families;
        PangoFontFamily **families;
        fontmap = pango_cairo_font_map_get_default();
        pango_font_map_list_families (fontmap, &families, &n_families);
        g_free(families);
        return 0;
      }
    EOS
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libpng = Formula["libpng"]
    pixman = Formula["pixman"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/pango-1.0
      -I#{libpng.opt_include}/libpng16
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{cairo.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lcairo
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
