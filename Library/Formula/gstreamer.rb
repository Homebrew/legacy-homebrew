require 'formula'

class Gstreamer < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.2.0.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gstreamer-1.2.0.tar.xz'
  sha256 '94af5274299f845adf41cc504e0209b269acab7721293f49850fea27b4099463'

  def patches; DATA; end

  head do
    url 'git://anongit.freedesktop.org/gstreamer/gstreamer'

    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'gobject-introspection' => :optional
  depends_on 'gettext'
  depends_on 'glib'

  def install
    ENV.append "CFLAGS", "-funroll-loops -fstrict-aliasing -fno-common"

    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-gtk-doc
    ]

    if build.head?
      ENV.append "NOCONFIGURE", "yes"
      system "./autogen.sh"
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
end

__END__
diff --git a/gst/gstdatetime.c b/gst/gstdatetime.c
index 6a8f659..8384ece 100644
--- a/gst/gstdatetime.c
+++ b/gst/gstdatetime.c
@@ -21,8 +21,8 @@
 #include "config.h"
 #endif

-#include "glib-compat-private.h"
 #include "gst_private.h"
+#include "glib-compat-private.h"
 #include "gstdatetime.h"
 #include "gstvalue.h"
 #include <glib.h>
