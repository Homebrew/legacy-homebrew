class Librest < Formula
  desc "Library to access RESTful web services"
  homepage "https://wiki.gnome.org/Projects/Librest"
  url "https://download.gnome.org/sources/rest/0.7/rest-0.7.93.tar.xz"
  sha256 "c710644455340a44ddc005c645c466f05c0d779993138ea21a62c6082108b216"

  bottle do
    sha256 "9a85440762ae254d1dca4442499cef96777539cb6266e70a4b8dd72496ed1d25" => :el_capitan
    sha256 "31ffb12406788d8352991ce2342a1c971db18033bd140a19bfd7486664cd8235" => :yosemite
    sha256 "5350da99c8645c1b2f3ca7d00b5c9e11e25c7b8c9802dc697721a2f8bea7f2c0" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsoup"
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-gnome",
                          "--without-ca-certificates",
                          "--enable-introspection=yes"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdlib.h>
      #include <rest/rest-proxy.h>

      int main(int argc, char *argv[]) {
        RestProxy *proxy = rest_proxy_new("http://localhost", FALSE);

        g_object_unref(proxy);

        return EXIT_SUCCESS;
      }
    EOS
    glib = Formula["glib"]
    libsoup = Formula["libsoup"]
    flags = (ENV.cflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{libsoup.opt_include}/libsoup-2.4
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/rest-0.7
      -L#{libsoup.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lrest-0.7
      -lgobject-2.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
