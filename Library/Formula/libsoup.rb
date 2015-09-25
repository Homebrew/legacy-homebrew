class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://live.gnome.org/LibSoup"
  url "https://download.gnome.org/sources/libsoup/2.52/libsoup-2.52.0.tar.xz"
  sha256 "6c6c366622a1a9d938e0cea9b557fa536f088784251d31381ccd1b115a466785"

  bottle do
    sha256 "e0d3dbf2aa4195d18431df3a0ab3ec76d39cf8d16c92f197bbb44fd7dcd27f70" => :el_capitan
    sha256 "271aa21a2f6e318949eb0cb2c46e16580400a941d92a11bd10077f1210598aec" => :yosemite
    sha256 "0e65073606ae428ecd8c5992b458102e14c288e8ebd420e49929f1332aeeb37a" => :mavericks
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
