class Cairomm < Formula
  homepage "http://cairographics.org/cairomm/"
  url "http://cairographics.org/releases/cairomm-1.11.2.tar.gz"
  sha256 "ccf677098c1e08e189add0bd146f78498109f202575491a82f1815b6bc28008d"

  bottle do
    revision 1
    sha1 "11d150d437921cd03ec810690db1e12bf952a7cf" => :yosemite
    sha1 "17435d1a18ecda653fa71097ba9620b46421aabf" => :mavericks
    sha1 "3247ebe37140dc109465dcfc7b5df6d948690091" => :mountain_lion
  end

  option :cxx11

  deprecated_option "without-x" => "without-x11"

  depends_on "pkg-config" => :build
  if build.cxx11?
    depends_on "libsigc++" => "c++11"
  else
    depends_on "libsigc++"
  end

  depends_on "cairo"
  depends_on "libpng"
  depends_on :x11 => :recommended

  def install
    ENV.cxx11 if build.cxx11?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<-EOS.undent
      #include <string>
      #include <cairommconfig.h>
      #include <cairomm/context.h>
      #include <cairomm/surface.h>

      int main() {
        Cairo::RefPtr<Cairo::ImageSurface> surface =
          Cairo::ImageSurface::create(Cairo::FORMAT_ARGB32, 600, 400);

        Cairo::RefPtr<Cairo::Context> cr = Cairo::Context::create(surface);

        cr->save();
        cr->set_source_rgb(0.86, 0.85, 0.47);
        cr->paint();

        std::string filename = "image.png";
        surface->write_to_png(filename);
      }
    EOS
    args = %W[
      -I#{lib}/cairomm-1.0/include
      -I#{include}/cairomm-1.0
      -I#{Formula["cairo"].opt_include}/cairo
      -I#{Formula["freetype"].opt_include}/freetype2
      -I#{Formula["libsigc++"].opt_include}/sigc++-2.0
      -I#{Formula["libsigc++"].opt_lib}/sigc++-2.0/include
      -L#{lib}
      -lcairomm-1.0
      test.cc
      -o
      test
    ]
    system ENV.cxx, *args
    system "./test"
    File.exist? "image.png"
  end
end
