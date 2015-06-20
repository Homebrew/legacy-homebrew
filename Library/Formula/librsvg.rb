class Librsvg < Formula
  desc "Library to render SVG files using Cairo"
  homepage "https://live.gnome.org/LibRsvg"
  url "https://download.gnome.org/sources/librsvg/2.40/librsvg-2.40.9.tar.xz"
  sha256 "13964c5d35357552b47d365c34215eee0a63bf0e6059b689f048648c6bf5f43a"
  revision 1

  bottle do
    revision 1
    sha256 "f955dd5db15b8963cecbe16243d21672894a4486594610e71c24612ad4607259" => :yosemite
    sha256 "656a206ab678897eda447ab3f13681f5c133e00581aee70382de6707bed34a5d" => :mavericks
    sha256 "be9e61f02fe0d10f25d1980c56041c2856c65a69c02e19dd72ae04d05e634768" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3" => :optional
  depends_on "libcroco"
  depends_on "libgsf" => :optional
  depends_on "pango"

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--disable-Bsymbolic",
            "--enable-tools=yes",
            "--enable-pixbuf-loader=yes",
            "--enable-introspection=yes"]

    args << "--enable-svgz" if build.with? "libgsf"

    system "./configure", *args

    # disable updating gdk-pixbuf cache, we will do this manually in post_install
    # https://github.com/Homebrew/homebrew/issues/40833
    inreplace "gdk-pixbuf-loader/Makefile", "$(GDK_PIXBUF_QUERYLOADERS) > $(DESTDIR)$(gdk_pixbuf_cache_file) ;", ""

    system "make", "install",
      "gdk_pixbuf_binarydir=#{lib}/gdk-pixbuf-2.0/2.10.0/loaders",
      "gdk_pixbuf_moduledir=#{lib}/gdk-pixbuf-2.0/2.10.0/loaders"
  end

  def post_install
    # librsvg is not aware GDK_PIXBUF_MODULEDIR must be set
    # set GDK_PIXBUF_MODULEDIR and update loader cache
    ENV["GDK_PIXBUF_MODULEDIR"] = "#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/2.10.0/loaders"
    system "#{Formula["gdk-pixbuf"].opt_bin}/gdk-pixbuf-query-loaders", "--update-cache"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <librsvg/rsvg.h>

      int main(int argc, char *argv[]) {
        RsvgHandle *handle = rsvg_handle_new();
        return 0;
      }
    EOS
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libpng = Formula["libpng"]
    pixman = Formula["pixman"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/librsvg-2.0
      -I#{libpng.opt_include}/libpng16
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lcairo
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -lm
      -lrsvg-2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
