class Gssdp < Formula
  desc "GUPnP library for resource discovery and announcement over SSDP"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gssdp/0.14/gssdp-0.14.13.tar.xz"
  sha256 "43057f0e3c07a12ad698cfb70420da21fc6e6eefe3c83161ef69e8308979eaea"

  bottle do
    sha256 "81f04682a589403208f87da3f52a22e13c855eaeafba9e0a67a16a32798b7215" => :el_capitan
    sha256 "a4044ab3b0fcbfe6bc0110e9facf6bb7c5f2ff7cbf9718770f6a6e08fdd64fd9" => :yosemite
    sha256 "d6639f36269afccfde5d8b286cbb035be7ab1b7223f9267ca339d99b891782db" => :mavericks
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
