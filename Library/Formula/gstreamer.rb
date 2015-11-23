class Gstreamer < Formula
  desc "GStreamer is a development framework for multimedia applications"
  homepage "http://gstreamer.freedesktop.org/"
  url "https://download.gnome.org/sources/gstreamer/1.6/gstreamer-1.6.1.tar.xz"
  sha256 "973a3f213c8d41d6dd0e4e7e38fd6cccacd5ae1ac09e1179a8d5d869ef0a5c9c"

  bottle do
    sha256 "dbec8f67917ddd35c0441705d78d204b7f4203b11c69cf01b536226872d2681c" => :el_capitan
    sha256 "6acc4ac51cf32cf5ad738cd430db01a20e49be65652d1675b510d3cf58d908ed" => :yosemite
    sha256 "4f5516ae0b85327eb5bba76cdb81193fbc2bb35abbc04adfa3ce08d3c8ed0de3" => :mavericks
  end

  head do
    url "git://anongit.freedesktop.org/gstreamer/gstreamer"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gobject-introspection"
  depends_on "gettext"
  depends_on "glib"
  depends_on "bison"

  # Fix header file issue (exact OS versions affected unknown; first noticed on
  # Snow Leopard)
  # https://bugzilla.gnome.org/show_bug.cgi?id=756136
  patch :DATA if MacOS.version <= :mountain_lion

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-gtk-doc
      --enable-introspection=yes
    ]

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"

      # Ban trying to chown to root.
      # https://bugzilla.gnome.org/show_bug.cgi?id=750367
      args << "--with-ptp-helper-permissions=none"
    end

    # Look for plugins in HOMEBREW_PREFIX/lib/gstreamer-1.0 instead of
    # HOMEBREW_PREFIX/Cellar/gstreamer/1.0/lib/gstreamer-1.0, so we'll find
    # plugins installed by other packages without setting GST_PLUGIN_PATH in
    # the environment.
    inreplace "configure", 'PLUGINDIR="$full_var"',
      "PLUGINDIR=\"#{HOMEBREW_PREFIX}/lib/gstreamer-1.0\""

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"gst-inspect-1.0"
  end
end
__END__
diff --git a/libs/gst/helpers/gst-ptp-helper.c b/libs/gst/helpers/gst-ptp-helper.c
index 6c753df..5642741 100644
--- a/libs/gst/helpers/gst-ptp-helper.c
+++ b/libs/gst/helpers/gst-ptp-helper.c
@@ -37,6 +37,7 @@
 #include <sys/types.h>
 #include <errno.h>
 #include <sys/ioctl.h>
+#include <sys/socket.h>
 #include <net/if.h>
 #include <netinet/in.h>
 #include <string.h>
