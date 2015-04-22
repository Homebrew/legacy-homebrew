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

  depends_on "libpng"
  depends_on :x11 => :recommended

  if build.without? "x11"
    depends_on "cairo" => "without-x11"
  else
    depends_on "cairo"
  end

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
    system ENV.cxx, "-I#{HOMEBREW_PREFIX}/include/cairomm-1.0", "-I#{HOMEBREW_PREFIX}/lib/cairomm-1.0/include", "-I#{HOMEBREW_PREFIX}/include/cairo", "-I#{HOMEBREW_PREFIX}/include/glib-2.0", "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include", "-I#{HOMEBREW_PREFIX}/opt/gettext/include", "-I#{HOMEBREW_PREFIX}/include/pixman-1", "-I#{HOMEBREW_PREFIX}/include", "-I#{HOMEBREW_PREFIX}/include/freetype2", "-I#{HOMEBREW_PREFIX}/include/libpng16", "-I#{HOMEBREW_PREFIX}/include/sigc++-2.0", "-I#{HOMEBREW_PREFIX}/lib/sigc++-2.0/include", "test.cpp", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-lcairomm-1.0", "-lcairo", "-lsigc-2.0", "-o", "test"
    system "./test"
  end
end
