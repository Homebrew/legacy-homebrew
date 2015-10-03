class LibicalGlib < Formula
  desc "Wrapper of libical with support of GObject Introspection"
  homepage "https://wiki.gnome.org/Projects/libical-glib"
  url "https://download.gnome.org/sources/libical-glib/1.0/libical-glib-1.0.3.tar.xz"
  sha256 "75373fb778352656c6368ffa7b371afa2fd2e2579874b0ec653a443da7a72d36"

  bottle do
    sha256 "11888d4f8706743ac2e6413071e48685c15ca90f9dead726fdce5e7d67fcd605" => :yosemite
    sha256 "8c59dbcf73ac3226ab09a9524566f447e16569fcccfac8750c15b71f6f34f7d7" => :mavericks
    sha256 "891baef1405bfbdf2d10d6a43c08d4c289a6fd4d27f7e3b145538d3bd6849a88" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libical"
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <libical-glib/libical-glib.h>

      int main(int argc, char *argv[]) {
        ICalParser *parser = i_cal_parser_new();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libical = Formula["libical"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}
      -I#{libical.opt_include}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{libical.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lgobject-2.0
      -lical
      -lical-glib-1.0
      -licalss
      -licalvcal
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
