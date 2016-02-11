class Gupnp < Formula
  desc "Framework for creating UPnP devices and control points"
  homepage "https://wiki.gnome.org/Projects/GUPnP"
  url "https://download.gnome.org/sources/gupnp/0.20/gupnp-0.20.16.tar.xz"
  sha256 "ff1119eff12529c46837e03c742f69dc4fae48d59097d79582d38a383b832602"

  head do
    url "https://github.com/GNOME/gupnp.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gnome-common" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  bottle do
    sha256 "b0788f609fc704c4e8c4b43a08a47f3d91fbc039e8957b61fcf8e0420e92a56f" => :el_capitan
    sha256 "5fe19250a1d5da1674cbbd88a940910c9b24ade3bd7e49f9bfa23a32779e256e" => :yosemite
    sha256 "d2211b56feaa7c0ece990c42079b62145328eb4debf7bdd95a5f106ce72c4fc5" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libsoup"
  depends_on "gssdp"

  # REVIEW: if patch was applied in the next release
  # https://github.com/GNOME/gupnp/pull/1
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/51584eb/gupnp/patch-osx-uuid.diff"
    sha256 "9cca169cc830c331ac4246e0e87f5c0b47a85b045c4a0de7cd4999d89d2ab5ce"
  end

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
