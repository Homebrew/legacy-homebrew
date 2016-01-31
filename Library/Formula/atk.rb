class Atk < Formula
  desc "GNOME accessibility toolkit"
  homepage "https://library.gnome.org/devel/atk/"
  url "https://download.gnome.org/sources/atk/2.18/atk-2.18.0.tar.xz"
  sha256 "ce6c48d77bf951083029d5a396dd552d836fff3c1715d3a7022e917e46d0c92b"
  revision 1

  bottle do
    revision 1
    sha256 "35c6f979fd70a1d6795be0eb39af47ce2dc107ee37916463779edd4432005d7e" => :el_capitan
    sha256 "86f832cb5899fd42461aa8622bc29e5a63789426e928e20f092bb9268565d00c" => :yosemite
    sha256 "cb32c119e17261370f0aa7271686a3736b5d1f4bdda19f5bac7fde3f00532401" => :mavericks
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
