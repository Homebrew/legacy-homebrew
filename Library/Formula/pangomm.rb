class Pangomm < Formula
  homepage "http://www.pango.org/"
  url "http://ftp.gnome.org/pub/GNOME/sources/pangomm/2.36/pangomm-2.36.0.tar.xz"
  sha256 "a8d96952c708d7726bed260d693cece554f8f00e48b97cccfbf4f5690b6821f0"

  bottle do
    revision 1
    sha1 "f3eaeb1e10d6202cf2c705e218b603fb2823beb0" => :yosemite
    sha1 "999599894fce8a7bcbd3fb4f2e04e221c66b233e" => :mavericks
    sha1 "3df791891b37c582cad8712fe5a93d6c067ca90e" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glibmm"
  depends_on "cairomm"
  depends_on "pango"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <pangomm.h>
      int main(int argc, char *argv[])
      {
        Pango::FontDescription fd;
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{HOMEBREW_PREFIX}/include/pangomm-1.4", "-I#{HOMEBREW_PREFIX}/lib/pangomm-1.4/include", "-I#{HOMEBREW_PREFIX}/include/glibmm-2.4", "-I#{HOMEBREW_PREFIX}/lib/glibmm-2.4/include", "-I#{HOMEBREW_PREFIX}/include/cairomm-1.0", "-I#{HOMEBREW_PREFIX}/lib/cairomm-1.0/include", "-I#{HOMEBREW_PREFIX}/include/sigc++-2.0", "-I#{HOMEBREW_PREFIX}/lib/sigc++-2.0/include", "-I#{HOMEBREW_PREFIX}/include/pango-1.0", "-I#{HOMEBREW_PREFIX}/include/cairo", "-I#{HOMEBREW_PREFIX}/include/glib-2.0", "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include", "-I#{HOMEBREW_PREFIX}/opt/gettext/include", "-I#{HOMEBREW_PREFIX}/include/pixman-1", "-I#{HOMEBREW_PREFIX}/include", "-I#{HOMEBREW_PREFIX}/include/freetype2", "-I#{HOMEBREW_PREFIX}/include/libpng16", "test.cpp", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/opt/gettext/lib", "-L#{HOMEBREW_PREFIX}/lib", "-lpangomm-1.4", "-lglibmm-2.4", "-lcairomm-1.0", "-lsigc-2.0", "-lpangocairo-1.0", "-lpango-1.0", "-lgobject-2.0", "-lglib-2.0", "-lintl", "-lcairo", "-o", "test"
    system "./test"
  end
end
