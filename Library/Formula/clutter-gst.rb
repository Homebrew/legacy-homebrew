class ClutterGst < Formula
  homepage "https://developer.gnome.org/clutter-gst/"
  url "http://ftp.gnome.org/pub/gnome/sources/clutter-gst/2.0/clutter-gst-2.0.12.tar.xz"
  sha256 "c2f1453692b0c3ff6a500113bc1d2c95d2bde11caca0809610a6d1424bbbffb5"

  bottle do
    sha1 "ff6322e999926cc302578cd5de6ac65be942cc64" => :yosemite
    sha1 "e6bd1433a8fe044451d85e1b4f92d4acaf98fc88" => :mavericks
    sha1 "0ddad83d563bb159d40b80918c40ef8db0c7113c" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gst-plugins-base"
  depends_on "clutter"
  depends_on "gobject-introspection"

  # Bug 729338 - got error: use of undeclared identifier 'GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS'
  # see: https://bugzilla.gnome.org/show_bug.cgi?id=729338
  patch :DATA

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --prefix=#{prefix}
      --enable-introspection=yes
      --disable-silent-rules
      --disable-gtk-doc-html
    ]
    ENV.append "CFLAGS", "-framework OpenGL"
    ENV.append "LDFLAGS", "-framework OpenGL"

    system "./configure", *args
    system "make", "install"
  end
end

__END__
diff --git a/clutter-gst/clutter-gst-video-sink.c b/clutter-gst/clutter-gst-vide
o-sink.c
index 63867d4..af9fc83 100644
--- a/clutter-gst/clutter-gst-video-sink.c
+++ b/clutter-gst/clutter-gst-video-sink.c
@@ -69,6 +69,10 @@
 #include <gst/video/gstsurfacemeta.h>
 #endif

+#ifdef CLUTTER_WINDOWING_OSX
+#include <OpenGL/GL.h>
+#endif
+
 #include <glib.h>
 #include <string.h>
