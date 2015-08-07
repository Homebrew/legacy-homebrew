class Gupnp < Formula
  desc "Framework for creating UPnP devices and control points"
  homepage "https://wiki.gnome.org/Projects/GUPnP"
  url "https://download.gnome.org/sources/gupnp/0.20/gupnp-0.20.14.tar.xz"
  sha256 "77ffb940ba77c4a6426d09d41004c75d92652dcbde86c84ac1c847dbd9ad59bd"

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
    sha256 "1109087b4b77ce974f4e435e4c27cd3b1aa49b0d2993ff1aed0f9148dd4c6033" => :yosemite
    sha256 "239c762f839d1aea6aebbe320e87cac9602986ef54c8994b88b650e6977f8ce2" => :mavericks
    sha256 "07e09de0ee06b0140bcd99d9f25f5d2163d21ae50f4e3ec1147ac25b978b6466" => :mountain_lion
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
    url "https://trac.macports.org/export/136642/users/devans/GNOME-3/stable/dports/net/gupnp/files/patch-osx-uuid.diff"
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
