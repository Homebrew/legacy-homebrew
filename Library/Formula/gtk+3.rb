class Gtkx3 < Formula
  homepage "http://gtk.org/"
  url "http://ftp.gnome.org/pub/gnome/sources/gtk+/3.16/gtk+-3.16.2.tar.xz"
  sha256 "a03963a61c9f5253a8d4003187190be165d92f95acf97ca783735071a8781cfa"

  bottle do
    sha1 "f2074aa249d5695a575a210d2452e8182f8c3435" => :yosemite
    sha1 "406cc2d01dadccd00a995459c8f16d0e4fab7299" => :mavericks
    sha1 "abe63c674b9bf60027629c480536ae8454a6ab29" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "gdk-pixbuf"
  depends_on "jasper" => :optional
  depends_on "atk"
  depends_on "gobject-introspection"
  depends_on "libepoxy"
  depends_on "gsettings-desktop-schemas" => :recommended
  depends_on "pango"
  depends_on "glib"

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-glibtest
      --enable-introspection=yes
      --disable-schemas-compile
      --enable-quartz-backend
      --enable-quartz-relocation
      --disable-x11-backend
    ]

    system "./configure", *args
    # necessary to avoid gtk-update-icon-cache not being found during make install
    bin.mkpath
    ENV.prepend_path "PATH", "#{bin}"
    system "make", "install"
    # Prevent a conflict between this and Gtk+2
    mv bin/"gtk-update-icon-cache", bin/"gtk3-update-icon-cache"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        gtk_disable_setlocale();
        return 0;
      }
    EOS
    system ENV.cc, "-I#{HOMEBREW_PREFIX}/include/gtk-3.0", "-I#{HOMEBREW_PREFIX}/include", "-I#{HOMEBREW_PREFIX}/include/gio-unix-2.0/", "-I#{HOMEBREW_PREFIX}/include/cairo", "-I#{HOMEBREW_PREFIX}/include", "-I#{HOMEBREW_PREFIX}/include/pango-1.0", "-I#{HOMEBREW_PREFIX}/include/atk-1.0", "-I#{HOMEBREW_PREFIX}/include/cairo", "-I#{HOMEBREW_PREFIX}/include/pixman-1", "-I#{HOMEBREW_PREFIX}/include", "-I#{HOMEBREW_PREFIX}/include/freetype2", "-I#{HOMEBREW_PREFIX}/include/libpng16", "-I#{HOMEBREW_PREFIX}/include/gdk-pixbuf-2.0", "-I#{HOMEBREW_PREFIX}/include/libpng16", "-I#{HOMEBREW_PREFIX}/include/glib-2.0", "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include", "-I#{HOMEBREW_PREFIX}/opt/gettext/include", "-I/opt/X11/include", "test.c", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/opt/gettext/lib", "-lgtk-3", "-lgdk-3", "-lpangocairo-1.0", "-lpango-1.0", "-latk-1.0", "-lcairo-gobject", "-lcairo", "-lgdk_pixbuf-2.0", "-lgio-2.0", "-lgobject-2.0", "-lglib-2.0", "-lintl", "-o", "test"
    system "./test"
  end
end
