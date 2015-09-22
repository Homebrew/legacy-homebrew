class Atk < Formula
  desc "GNOME accessibility toolkit"
  homepage "https://library.gnome.org/devel/atk/"
  url "https://download.gnome.org/sources/atk/2.18/atk-2.18.0.tar.xz"
  sha256 "ce6c48d77bf951083029d5a396dd552d836fff3c1715d3a7022e917e46d0c92b"

  bottle do
    sha256 "67f3e86e1f8a7907bb87f51f2f6f16d43fac06377c2aac6815b47b1e70cbef0c" => :el_capitan
    sha256 "b0aa68237cb50981c19a7c2b5873a17d30912cac2bd6c9aedf6a5fb297d9e4dd" => :yosemite
    sha256 "a0b8f30dd3a0fdce58456be54b5b57793265a42644b6a2a05124bfb1809cea40" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  option :universal

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
