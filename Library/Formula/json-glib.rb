class JsonGlib < Formula
  homepage "https://live.gnome.org/JsonGlib"
  url "http://ftp.gnome.org/pub/gnome/sources/json-glib/1.0/json-glib-1.0.4.tar.xz"
  sha256 "80f3593cb6bd13f1465828e46a9f740e2e9bd3cd2257889442b3e62bd6de05cd"

  bottle do
    revision 2
    sha1 "58daae021ca6c990a0e29e5b7c72699ca4e4800a" => :yosemite
    sha1 "18168428af31175e10e4c9f52809c58c6afebc22" => :mavericks
    sha1 "64de84e6abc6bcc2700e45d6288646d14bf5fc05" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <json-glib/json-glib.h>

      int main(int argc, char *argv[]) {
        JsonParser *parser = json_parser_new();
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
      -I#{include}/json-glib-1.0
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -ljson-glib-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
