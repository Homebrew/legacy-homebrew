class Gtkx < Formula
  homepage "http://gtk.org/"
  url "https://download.gnome.org/sources/gtk+/2.24/gtk+-2.24.27.tar.xz"
  sha256 "20cb10cae43999732a9af2e9aac4d1adebf2a9c2e1ba147050976abca5cd24f4"

  bottle do
    sha256 "ab144b55ebb1829ac4e01b9774c0293eb219e1564581e1f139d3eb48db7cd00e" => :yosemite
    sha256 "e94e9a89a0f7c7026700cfd17e4468b08215056cf24e867e8f14198110fed2e5" => :mavericks
    sha256 "98d5cd5c5635f5ee0aaf1376958e57a62f2ef72ff7ff6078e2dad25d0dcc6780" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gdk-pixbuf"
  depends_on "jasper" => :optional
  depends_on "atk"
  depends_on "pango"
  depends_on :x11 => ["2.3.6", :recommended]
  depends_on "gobject-introspection"

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    args = ["--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}",
            "--disable-glibtest",
            "--enable-introspection=yes",
            "--disable-visibility"]

    args << "--with-gdktarget=quartz" if build.without?("x11")
    args << "--enable-quartz-relocation" if build.without?("x11")

    system "./configure", *args
    system "make", "install"
  end
  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        GtkWidget *label = gtk_label_new("Hello World!");
        return 0;
      }
    EOS
    system ENV.cc, "-I#{HOMEBREW_PREFIX}/include/gtk-2.0", "-I#{HOMEBREW_PREFIX}/lib/gtk-2.0/include", "-I#{HOMEBREW_PREFIX}/include/pango-1.0", "-I#{HOMEBREW_PREFIX}/include/atk-1.0", "-I#{HOMEBREW_PREFIX}/include/cairo", "-I#{HOMEBREW_PREFIX}/include/pixman-1", "-I#{HOMEBREW_PREFIX}/include/libpng16", "-I#{HOMEBREW_PREFIX}/include/gdk-pixbuf-2.0", "-I#{HOMEBREW_PREFIX}/include/libpng16", "-I#{HOMEBREW_PREFIX}/include/pango-1.0", "-I#{HOMEBREW_PREFIX}/include/harfbuzz", "-I#{HOMEBREW_PREFIX}/include/pango-1.0", "-I#{HOMEBREW_PREFIX}/include/glib-2.0", "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include", "-I#{HOMEBREW_PREFIX}/opt/gettext/include", "-I#{HOMEBREW_PREFIX}/include", "-I#{HOMEBREW_PREFIX}/include/freetype2", "-I/opt/X11/include", "test.c", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/opt/gettext/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-lgtk-x11-2.0", "-lgdk-x11-2.0", "-lpangocairo-1.0", "-latk-1.0", "-lcairo", "-lgdk_pixbuf-2.0", "-lgio-2.0", "-lpangoft2-1.0", "-lpango-1.0", "-lgobject-2.0", "-lglib-2.0", "-lintl", "-lfontconfig", "-lfreetype", "-o", "test"
    system "./test"
  end
end
