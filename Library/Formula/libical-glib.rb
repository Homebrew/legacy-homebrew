class LibicalGlib < Formula
  desc "Wrapper of libical with support of GObject Introspection"
  homepage "https://wiki.gnome.org/Projects/libical-glib"
  url "https://download.gnome.org/sources/libical-glib/1.0/libical-glib-1.0.4.tar.xz"
  sha256 "3e47c7c19a403e77a598cfa8fc82c8e9ea0b3625e2f28bdcec096aeba37fb0cd"

  bottle do
    sha256 "8a6b485db04370ac7bb5accba6624b7bb0f6887121103154a679833c4f49cfcd" => :el_capitan
    sha256 "c026784a1bff6740004a9cfbdacc6e75003ea1aa3a1df28630658eee4fdeb065" => :yosemite
    sha256 "4a7e68b90cbb6e41395fe092ee6fc92f3816c9c65398e736dba70f5da1b4b120" => :mavericks
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
