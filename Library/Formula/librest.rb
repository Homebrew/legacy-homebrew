class Librest < Formula
  desc "Library to access RESTful web services"
  homepage "https://wiki.gnome.org/Projects/Librest"
  url "https://download.gnome.org/sources/rest/0.7/rest-0.7.93.tar.xz"
  sha256 "c710644455340a44ddc005c645c466f05c0d779993138ea21a62c6082108b216"

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
    flags = (ENV.cflags || "").split + (ENV.ldflags || "").split
    flags += `pkg-config --cflags --libs rest-0.7`.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
