class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "http://www.pango.org/"
  revision 2

  stable do
    url "https://download.gnome.org/sources/pango/1.36/pango-1.36.8.tar.xz"
    sha256 "18dbb51b8ae12bae0ab7a958e7cf3317c9acfc8a1e1103ec2f147164a0fc2d07"

    # [coretext] NULL check in ct_font_descriptor_get_weight()
    # This fixes crashes when displaying certain Unicode characters.
    # See: https://bugzilla.gnome.org/show_bug.cgi?id=736697
    patch do
      url "https://bug736697.bugzilla-attachments.gnome.org/attachment.cgi?id=286234"
      sha256 "08d803ddedfa98d99b1897c22a61b908cff05bd0e43982f3063f0d77e05ddb17"
    end
  end

  bottle do
    sha256 "176d23a9bcb5d74f8a170385313d148374d1ff3579c664bd5e8aa0dd9d6c0996" => :yosemite
    sha256 "f700167bd71a7f4f8c3ee195c973a355a8dbc70f098b9c12807fcf02087950d8" => :mavericks
    sha256 "fae52c828225d2d01a6840d20ce0300a98935b4dd4452ea904d96c0ea54047e7" => :mountain_lion
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
    system "#{bin}/pango-querymodules", "--version"
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
