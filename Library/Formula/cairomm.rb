class Cairomm < Formula
  desc "Vector graphics library with cross-device output support"
  homepage "http://cairographics.org/cairomm/"
  url "https://download.gnome.org/sources/cairomm/1.12/cairomm-1.12.0.tar.xz"
  sha256 "a54ada8394a86182525c0762e6f50db6b9212a2109280d13ec6a0b29bfd1afe6"

  bottle do
    cellar :any
    sha256 "b05ec638711634ad01ab1aec44eb9397e7a67278eaa5fefd16403b240a5261b0" => :el_capitan
    sha256 "98648d8f66c07f55192908271f80233a78dfe65af96c6d8f06af209e30b3d980" => :yosemite
    sha256 "960d0180b4e5137d56d8d2051e21fdcbcf23ebd18ff94fa03f0d39a20853b70d" => :mavericks
  end

  needs :cxx11

  depends_on "pkg-config" => :build
  depends_on "libsigc++"

  depends_on "libpng"
  depends_on "cairo"

  def install
    ENV.cxx11
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
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
