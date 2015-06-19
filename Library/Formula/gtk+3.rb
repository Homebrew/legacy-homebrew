class Gtkx3 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "http://gtk.org/"
  url "https://download.gnome.org/sources/gtk+/3.16/gtk+-3.16.4.tar.xz"
  sha256 "1ee5dbd7a4cb81a91eaa1b7ae64ba5a3eab6a3c0a764155583ab96524590fc8e"
  revision 1

  bottle do
    sha256 "6c32e525805e77f5c98566e913202004c4008a14eafbaf3ec6030857bfe22d8e" => :yosemite
    sha256 "29a0ff441dda9e47c264db0a9c8848c9585018806ac6b2b051d04761b2124775" => :mavericks
    sha256 "a3d3e375dca6a73346a73946b8e6bf43fe570ac17c0df5f04051eecc1caaa019" => :mountain_lion
  end

  option :universal
  option "with-quartz-relocation", "Build with quartz relocation support"
  option "without-icons", "Do not install Adwaita icon theme for basic icon support (not recommended)"

  depends_on "pkg-config" => :build
  depends_on "gdk-pixbuf"
  depends_on "jasper" => :optional
  depends_on "atk"
  depends_on "gobject-introspection"
  depends_on "libepoxy"
  depends_on "gsettings-desktop-schemas" => :recommended
  depends_on "pango"
  depends_on "glib"

  if build.with?("icons")
    # Adwaita icon theme dependencies
    depends_on "gettext" => :build
    depends_on "icon-naming-utils" => :build
    depends_on "intltool" => :build
    depends_on "librsvg"
  end

  resource "adwaita-icon-theme" do
    url "https://download.gnome.org/sources/adwaita-icon-theme/3.16/adwaita-icon-theme-3.16.2.1.tar.xz"
    sha256 "b4556dfbf555d4fac12d4d5c12f7519de0d43ec42a1b649611439a50bf7acb96"
  end

  def install
    ENV.universal_binary if build.universal?

    if File.exist?(HOMEBREW_PREFIX/"opt/gnome-icon-theme")
      raise "Please `brew rm gnome-icon-theme` - It has been merged with GTK+3"
    end

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-glibtest
      --enable-introspection=yes
      --disable-schemas-compile
      --enable-quartz-backend
      --disable-x11-backend
    ]

    args << "--enable-quartz-relocation" if build.with?("quartz-relocation")

    system "./configure", *args
    system "make", "install"
    # Prevent a conflict between this and Gtk+2
    mv bin/"gtk-update-icon-cache", bin/"gtk3-update-icon-cache"

    if build.with? "icons"
      resource("adwaita-icon-theme").stage do
        system "./configure", "--disable-dependency-tracking",
                              "--prefix=#{prefix}",
                              "GTK_UPDATE_ICON_CACHE=#{bin}/gtk3-update-icon-cache"
        system "make", "install"
      end
    end
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
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}
      -I#{include}/gtk-3.0
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-3
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
