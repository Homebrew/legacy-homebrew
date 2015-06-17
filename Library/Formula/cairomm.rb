class Cairomm < Formula
  desc "Vector graphics library with cross-device output support"
  homepage "http://cairographics.org/cairomm/"
  url "http://cairographics.org/releases/cairomm-1.11.2.tar.gz"
  sha256 "ccf677098c1e08e189add0bd146f78498109f202575491a82f1815b6bc28008d"
  revision 1

  bottle do
    revision 1
    sha256 "8e3d574df6640965c1801f0d70950b1f1b41031bddf82ccb109dcc11276bc78f" => :yosemite
    sha256 "27339feb44c56a23899bbadea5c085a99129ce6541b0d956909ccba9839fd841" => :mavericks
    sha256 "f38db939a7ff7b69742caef42ecbe5210dc4063c84dc11048430fc06f1bf186e" => :mountain_lion
  end

  option :cxx11

  depends_on "pkg-config" => :build
  if build.cxx11?
    depends_on "libsigc++" => "c++11"
  else
    depends_on "libsigc++"
  end

  depends_on "libpng"
  depends_on "cairo"

  def install
    ENV.cxx11 if build.cxx11?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <cairomm/cairomm.h>

      int main(int argc, char *argv[])
      {
         Cairo::RefPtr<Cairo::ImageSurface> surface = Cairo::ImageSurface::create(Cairo::FORMAT_ARGB32, 600, 400);
         Cairo::RefPtr<Cairo::Context> cr = Cairo::Context::create(surface);
         return 0;
      }
    EOS
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libpng = Formula["libpng"]
    libsigcxx = Formula["libsigc++"]
    pixman = Formula["pixman"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/cairomm-1.0
      -I#{libpng.opt_include}/libpng16
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/cairomm-1.0/include
      -I#{pixman.opt_include}/pixman-1
      -L#{cairo.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -lcairo
      -lcairomm-1.0
      -lsigc-2.0
    ]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
