class Gssdp < Formula
  desc "GUPnP library for resource discovery and announcement over SSDP"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gssdp/0.14/gssdp-0.14.14.tar.xz"
  sha256 "685718755b5b8d24aaeadda44047e515443784712891fc53879ab9a4865b48d6"

  bottle do
    sha256 "0472c58015680bdeafdf065d1b1faebc42b7ae7b1ee1ab063f683b3a34d8692a" => :el_capitan
    sha256 "bc2db9b2ce31a9c31fa1bc3ab4f19e3a3e1918576c15704fa281d82eb0646fa1" => :yosemite
    sha256 "f5f26b0097b89d8ec488754cb3016e727e4c2010043ae84332c214399ef96256" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libsoup"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <libgssdp/gssdp.h>

      int main(int argc, char *argv[]) {
        GType type = gssdp_client_get_type();
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
      -I#{include}/gssdp-1.0
      -D_REENTRANT
      -L#{lib}
      -lgssdp-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
