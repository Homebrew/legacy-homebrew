class Cairo < Formula
  homepage "http://cairographics.org/"
  url "http://cairographics.org/releases/cairo-1.14.2.tar.xz"
  mirror "http://www.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/cairo-1.14.2.tar.xz"
  sha256 "c919d999ddb1bbbecd4bbe65299ca2abd2079c7e13d224577895afa7005ecceb"

  bottle do
    sha256 "86672344ecd86346a890952f6038e943d95080d15d9eafc06e417fd6dc301791" => :yosemite
    sha256 "50e7a59e4d6a1aff9c972ea6697be32dd052ed771b35a32188d5f150a4db7964" => :mavericks
    sha256 "a860e936571129c55ef8098bcbfda6dffa7970c49d2908e96a1a8a50f55399a4" => :mountain_lion
  end

  keg_only :provided_pre_mountain_lion

  option :universal

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "fontconfig"
  depends_on "libpng"
  depends_on "pixman"
  depends_on "glib"
  depends_on :x11

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-gobject=yes
      --enable-svg=yes
      --enable-tee=yes
      --with-x
      --enable-quartz-image
    ]

    args << "--enable-xcb=no" if MacOS.version <= :leopard

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
    system ENV.cc, "-I#{HOMEBREW_PREFIX}/include/cairo", "-I#{HOMEBREW_PREFIX}/include/glib-2.0", "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include", "-I#{HOMEBREW_PREFIX}/opt/gettext/include", "-I#{HOMEBREW_PREFIX}/include/pixman-1", "-I#{HOMEBREW_PREFIX}/include", "-I#{HOMEBREW_PREFIX}/include/freetype2", "-I#{HOMEBREW_PREFIX}/include/libpng16", "-I/opt/X11/include", "test.c", "-L#{HOMEBREW_PREFIX}/lib", "-lcairo", "-o", "test"
    system "./test"
  end
end
