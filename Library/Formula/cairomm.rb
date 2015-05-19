class Cairomm < Formula
  desc "Vector graphics library with cross-device output support"
  homepage "http://cairographics.org/cairomm/"
  url "http://cairographics.org/releases/cairomm-1.11.2.tar.gz"
  sha256 "ccf677098c1e08e189add0bd146f78498109f202575491a82f1815b6bc28008d"

  bottle do
    sha256 "0de6d6e44c5e25a7c74cf8e7e0a57f96354603b57ef81550f2862cf44f2826d5" => :yosemite
    sha256 "97daf82719e87af9df0788eb00d43035f66bebe87d385f100508de80d4e788da" => :mavericks
    sha256 "0a706ff9d219ed40ee0bad185d34a060a46a38f60a68f65971a328b6afa0fd5d" => :mountain_lion
  end

  option :cxx11

  deprecated_option "without-x" => "without-x11"

  depends_on "pkg-config" => :build
  if build.cxx11?
    depends_on "libsigc++" => "c++11"
  else
    depends_on "libsigc++"
  end

  depends_on "libpng"
  depends_on "cairo"
  depends_on :x11 => :recommended

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
