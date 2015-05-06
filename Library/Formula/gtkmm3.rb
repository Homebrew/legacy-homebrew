class Gtkmm3 < Formula
  homepage "http://www.gtkmm.org/"
  url "http://ftp.gnome.org/pub/GNOME/sources/gtkmm/3.16/gtkmm-3.16.0.tar.xz"
  sha256 "9b8d4af5e1bb64e52b53bc8ef471ef43e1b9d11a829f16ef54c3a92985b0dd0c"

  bottle do
    sha256 "a07b50d5f0475e3b785400c90ab17912fb036f6c5e04a07f4c63bfb7791bef34" => :yosemite
    sha256 "b84fc730de0e85f86240c163d74b42ae102d48f2ad86293993b44fa6d6446f6a" => :mavericks
    sha256 "bd7fdbe8a9da123648398405e4421f9ec0b205b6d9f0850b21400dd7d387a7d3" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "pangomm"
  depends_on "atkmm"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <gtkmm.h>
      class MyLabel : public Gtk::Label {
        MyLabel(Glib::ustring text) : Gtk::Label(text) {}
      };
      int main(int argc, char *argv[]) {
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{HOMEBREW_PREFIX}/include/gtkmm-3.0", "-I#{HOMEBREW_PREFIX}/lib/gtkmm-3.0/include", "-I#{HOMEBREW_PREFIX}/include/atkmm-1.6", "-I#{HOMEBREW_PREFIX}/include/gtk-3.0/unix-print", "-I#{HOMEBREW_PREFIX}/include/gdkmm-3.0", "-I#{HOMEBREW_PREFIX}/lib/gdkmm-3.0/include", "-I#{HOMEBREW_PREFIX}/include/giomm-2.4", "-I#{HOMEBREW_PREFIX}/lib/giomm-2.4/include", "-I#{HOMEBREW_PREFIX}/include/pangomm-1.4", "-I#{HOMEBREW_PREFIX}/lib/pangomm-1.4/include", "-I#{HOMEBREW_PREFIX}/include/glibmm-2.4", "-I#{HOMEBREW_PREFIX}/lib/glibmm-2.4/include", "-I#{HOMEBREW_PREFIX}/include/gtk-3.0", "-I#{HOMEBREW_PREFIX}/include", "-I#{HOMEBREW_PREFIX}/include/gio-unix-2.0/", "-I#{HOMEBREW_PREFIX}/include/cairo", "-I#{HOMEBREW_PREFIX}/include", "-I#{HOMEBREW_PREFIX}/include/pango-1.0", "-I#{HOMEBREW_PREFIX}/include/atk-1.0", "-I#{HOMEBREW_PREFIX}/include/cairo", "-I#{HOMEBREW_PREFIX}/include/cairomm-1.0", "-I#{HOMEBREW_PREFIX}/lib/cairomm-1.0/include", "-I#{HOMEBREW_PREFIX}/include/cairo", "-I#{HOMEBREW_PREFIX}/include/pixman-1", "-I#{HOMEBREW_PREFIX}/include", "-I#{HOMEBREW_PREFIX}/include/freetype2", "-I#{HOMEBREW_PREFIX}/include/libpng16", "-I#{HOMEBREW_PREFIX}/include/sigc++-2.0", "-I#{HOMEBREW_PREFIX}/lib/sigc++-2.0/include", "-I#{HOMEBREW_PREFIX}/include/gdk-pixbuf-2.0", "-I#{HOMEBREW_PREFIX}/include/libpng16", "-I#{HOMEBREW_PREFIX}/include/glib-2.0", "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include", "-I#{HOMEBREW_PREFIX}/opt/gettext/include", "-I/opt/X11/include", "test.cpp", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/opt/gettext/lib", "-lgtkmm-3.0", "-latkmm-1.6", "-lgdkmm-3.0", "-lgiomm-2.4", "-lpangomm-1.4", "-lglibmm-2.4", "-lgtk-3", "-lgdk-3", "-lpangocairo-1.0", "-lpango-1.0", "-latk-1.0", "-lcairo-gobject", "-lgio-2.0", "-lcairomm-1.0", "-lcairo", "-lsigc-2.0", "-lgdk_pixbuf-2.0", "-lgobject-2.0", "-lglib-2.0", "-lintl", "-o", "test"
    system "./test"
  end
end
