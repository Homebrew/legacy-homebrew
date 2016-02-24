class Atk < Formula
  desc "GNOME accessibility toolkit"
  homepage "https://library.gnome.org/devel/atk/"
  url "https://download.gnome.org/sources/atk/2.18/atk-2.18.0.tar.xz"
  sha256 "ce6c48d77bf951083029d5a396dd552d836fff3c1715d3a7022e917e46d0c92b"
  revision 1

  bottle do
    sha256 "fe1c92ea4289e68e062a861b7b150ccf69beba70e95d38f7f028b52ca2f6314d" => :el_capitan
    sha256 "7cd7097c3dd7a00e9a16bd22740e1dc242ca7a6e8e7d78d35204ecfa345e8c44" => :yosemite
    sha256 "2b108c87daaaf48d7628f8e4187533533c726331c55d0182327551366525829b" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <atk/atk.h>

      int main(int argc, char *argv[]) {
        const gchar *version = atk_get_version();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/atk-1.0
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -latk-1.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
