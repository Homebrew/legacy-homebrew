class Gupnp < Formula
  homepage "https://wiki.gnome.org/Projects/GUPnP"
  url "https://download.gnome.org/sources/gupnp/0.20/gupnp-0.20.13.tar.xz"
  sha256 "d779b094f13097a5900689b3587e5b495d79112d0855ed842577acba25c902b3"

  head do
    url "https://github.com/GNOME/gupnp.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gnome-common" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha1 "7e087d225faef24ee34409c6270f6fb61d0a4363" => :yosemite
    sha1 "b655501ca5f652c9c50cefc5de947879bea10ea8" => :mavericks
    sha1 "32aa5ac058cfa42c20dbdc3f92684cd6ce57a9d4" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libsoup"
  depends_on "gssdp"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]
    if build.head?
      ENV.append "CFLAGS", "-I/usr/include/uuid"
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    system bin/"gupnp-binding-tool", "--help"
    (testpath/"test.c").write <<-EOS.undent
      #include <libgupnp/gupnp-control-point.h>

      static GMainLoop *main_loop;

      int main (int argc, char **argv)
      {
        GUPnPContext *context;
        GUPnPControlPoint *cp;

        context = gupnp_context_new (NULL, NULL, 0, NULL);
        cp = gupnp_control_point_new
          (context, "urn:schemas-upnp-org:service:WANIPConnection:1");

        main_loop = g_main_loop_new (NULL, FALSE);
        g_main_loop_unref (main_loop);
        g_object_unref (cp);
        g_object_unref (context);

        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/gupnp-1.0", "-L#{lib}", "-lgupnp-1.0",
           "-I#{Formula["gssdp"].opt_include}/gssdp-1.0",
           "-I#{Formula["gssdp"].opt_lib}", "-lgssdp-1.0",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           "-lglib-2.0", "-lgobject-2.0",
           "-I#{Formula["libsoup"].opt_include}/libsoup-2.4",
           "-I/usr/include/libxml2",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
