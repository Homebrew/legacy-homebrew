class Cairo < Formula
  desc "Vector graphics library with cross-device output support"
  homepage "http://cairographics.org/"
  url "http://cairographics.org/releases/cairo-1.14.6.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/cairo-1.14.6.tar.xz"
  sha256 "613cb38447b76a93ff7235e17acd55a78b52ea84a9df128c3f2257f8eaa7b252"
  revision 1

  bottle do
    sha256 "dd4dc801ee427ca2d2305403cacf747a51b58d80a2cd2ebf20a9623229830278" => :el_capitan
    sha256 "3ac3b4af558425ff4c3a9799bfb24ab70e41210d63323195db4a5e6feb790497" => :yosemite
    sha256 "15ec1a777186dc6af988c9d1de94449ce730ec64a1588d63f3a1b95222d75a8d" => :mavericks
  end

  devel do
    url "http://cairographics.org/snapshots/cairo-1.15.2.tar.xz"
    sha256 "268cc265a7f807403582f440643064bf52896556766890c8df7bad02d230f6c9"
  end

  keg_only :provided_pre_mountain_lion

  option :universal

  depends_on "pkg-config" => :build
  depends_on :x11 => :optional if MacOS.version > :leopard
  depends_on "freetype"
  depends_on "fontconfig"
  depends_on "libpng"
  depends_on "pixman"
  depends_on "glib"

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-gobject=yes
      --enable-svg=yes
      --enable-tee=yes
      --enable-quartz-image
    ]

    if build.with? "x11"
      args << "--enable-xcb=yes" << "--enable-xlib=yes" << "--enable-xlib-xrender=yes"
    else
      args << "--enable-xcb=no" << "--enable-xlib=no" << "--enable-xlib-xrender=no"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <cairo.h>

      int main(int argc, char *argv[]) {

        cairo_surface_t *surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 600, 400);
        cairo_t *context = cairo_create(surface);

        return 0;
      }
    EOS
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libpng = Formula["libpng"]
    pixman = Formula["pixman"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/cairo
      -I#{libpng.opt_include}/libpng16
      -I#{pixman.opt_include}/pixman-1
      -L#{lib}
      -lcairo
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
