require "formula"

class ClutterGst < Formula
  homepage "https://wiki.gnome.org/Clutter"
  url "http://ftp.gnome.org/pub/gnome/sources/clutter-gst/2.0/clutter-gst-2.0.10.tar.xz"
  sha256 "f00cf492a6d4f1036c70d8a0ebd2f0f47586ea9a9b49b1ffda79c9dc7eadca00"

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
    system "make install"
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
