class Gtkmm < Formula
  homepage "http://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/2.24/gtkmm-2.24.4.tar.xz"
  sha256 "443a2ff3fcb42a915609f1779000390c640a6d7fd19ad8816e6161053696f5ee"

  bottle do
    revision 2
    sha256 "25747117e0d2b6ff8b012f80c0846ff50fbd3e6175d49d275838df12278d7a69" => :yosemite
    sha256 "b577998a68e274e8badbd22f45f2741865332fe3cec53f7fa201092f11dd32c7" => :mavericks
    sha256 "af35b5d473fce6db31d08e6d2e4939873ce8ef51675885a24e58c489a678be66" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glibmm"
  depends_on "gtk+"
  depends_on "libsigc++"
  depends_on "pangomm"
  depends_on "atkmm"
  depends_on "cairomm"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <gtkmm.h>

      int main(int argc, char *argv[]) {
        Gtk::Label label("Hello World!");
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{HOMEBREW_PREFIX}/include/gtkmm-2.4", "-I#{HOMEBREW_PREFIX}/lib/gtkmm-2.4/include", "-I#{HOMEBREW_PREFIX}/include/atkmm-1.6", "-I#{HOMEBREW_PREFIX}/include/gtk-unix-print-2.0", "-I#{HOMEBREW_PREFIX}/include/gtk-2.0", "-I#{HOMEBREW_PREFIX}/include/gdkmm-2.4", "-I#{HOMEBREW_PREFIX}/lib/gdkmm-2.4/include", "-I#{HOMEBREW_PREFIX}/include/giomm-2.4", "-I#{HOMEBREW_PREFIX}/lib/giomm-2.4/include", "-I#{HOMEBREW_PREFIX}/include/pangomm-1.4", "-I#{HOMEBREW_PREFIX}/lib/pangomm-1.4/include", "-I#{HOMEBREW_PREFIX}/include/glibmm-2.4", "-I#{HOMEBREW_PREFIX}/lib/glibmm-2.4/include", "-I#{HOMEBREW_PREFIX}/include/cairomm-1.0", "-I#{HOMEBREW_PREFIX}/lib/cairomm-1.0/include", "-I#{HOMEBREW_PREFIX}/include/sigc++-2.0", "-I#{HOMEBREW_PREFIX}/lib/sigc++-2.0/include", "-I#{HOMEBREW_PREFIX}/include/gtk-2.0", "-I#{HOMEBREW_PREFIX}/lib/gtk-2.0/include", "-I#{HOMEBREW_PREFIX}/include/pango-1.0", "-I#{HOMEBREW_PREFIX}/include/atk-1.0", "-I#{HOMEBREW_PREFIX}/include/cairo", "-I#{HOMEBREW_PREFIX}/include/pixman-1", "-I#{HOMEBREW_PREFIX}/include/libpng16", "-I#{HOMEBREW_PREFIX}/include/gdk-pixbuf-2.0", "-I#{HOMEBREW_PREFIX}/include/libpng16", "-I#{HOMEBREW_PREFIX}/include/pango-1.0", "-I#{HOMEBREW_PREFIX}/include/harfbuzz", "-I#{HOMEBREW_PREFIX}/include/pango-1.0", "-I#{HOMEBREW_PREFIX}/include/glib-2.0", "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include", "-I#{HOMEBREW_PREFIX}/opt/gettext/include", "-I#{HOMEBREW_PREFIX}/include", "-I#{HOMEBREW_PREFIX}/include/freetype2", "-I/opt/X11/include", "test.cpp", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/opt/gettext/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-lgtkmm-2.4", "-latkmm-1.6", "-lgtk-x11-2.0", "-lgdkmm-2.4", "-lgiomm-2.4", "-lpangomm-1.4", "-lglibmm-2.4", "-lcairomm-1.0", "-lsigc-2.0", "-lgtk-x11-2.0", "-lgdk-x11-2.0", "-lpangocairo-1.0", "-latk-1.0", "-lcairo", "-lgdk_pixbuf-2.0", "-lgio-2.0", "-lpangoft2-1.0", "-lpango-1.0", "-lgobject-2.0", "-lglib-2.0", "-lintl", "-lfontconfig", "-lfreetype", "-o", "test"
    system "./test"
  end
end
