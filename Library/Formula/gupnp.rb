class Gupnp < Formula
  desc "Framework for creating UPnP devices and control points"
  homepage "https://wiki.gnome.org/Projects/GUPnP"
  url "https://download.gnome.org/sources/gupnp/0.20/gupnp-0.20.16.tar.xz"
  sha256 "ff1119eff12529c46837e03c742f69dc4fae48d59097d79582d38a383b832602"

  bottle do
    sha256 "1795f4230bf9473c0efbb6b8e2a2623d94d3df0f2517c3da3d6a712ecd016594" => :el_capitan
    sha256 "9155fdd46f4a19b558a74007eb10eec648c91c24dbe51c14b9146e7c19d45be7" => :yosemite
    sha256 "38f16ce2e0d5a52a00444f4c45b99537fe45764ed9bfa33c321fa40820119476" => :mavericks
  end

  head do
    url "https://github.com/GNOME/gupnp.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gnome-common" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
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
