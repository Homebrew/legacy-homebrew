class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://live.gnome.org/LibSoup"
  url "https://download.gnome.org/sources/libsoup/2.52/libsoup-2.52.2.tar.xz"
  sha256 "db55628b5c7d952945bb71b236469057c8dfb8dea0c271513579c6273c2093dc"

  bottle do
    sha256 "f690c3bdcf810826c4554a101ba39102a003327e7e71030a6c13f24cbac04233" => :el_capitan
    sha256 "672005c4674f59ef20130bd17c0573f92c6b501f4166eeb45a5fe7c6fcd8eae1" => :yosemite
    sha256 "78b5f71f42cd3fe02106db1ae54b17a8888fd76cb95f7adbaf06695ea91a7411" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "glib-networking"
  depends_on "gnutls"
  depends_on "sqlite"
  depends_on "gobject-introspection"
  depends_on "vala"

  def install
    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--without-gnome",
      "--disable-tls-check",
    ]

    # ensures that the vala files remain within the keg
    inreplace "libsoup/Makefile.in", "VAPIDIR = @VAPIDIR@", "VAPIDIR = @datadir@/vala/vapi"
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <libsoup/soup.h>

      int main(int argc, char *argv[]) {
        guint version = soup_get_major_version();
        return 0;
      }
    EOS
    ENV.libxml2
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libsoup-2.4
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -lsoup-2.4
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
