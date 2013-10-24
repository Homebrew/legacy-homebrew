require 'formula'

class Gstreamer010 < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-0.10.36.tar.bz2'
  sha256 'e556a529e0a8cf1cd0afd0cab2af5488c9524e7c3f409de29b5d82bb41ae7a30'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'

  # Fix sed version detection for 10.8
  # Reported and fixed upstream:
  # https://bugzilla.gnome.org/show_bug.cgi?id=680428
  # Fix header inclusion
  # http://cgit.freedesktop.org/gstreamer/gstreamer/commit/?id=2231721dddb9ba7db3d7566f64a6fa58fdd1ff9d
  def patches
    DATA
  end

  def install
    # Look for plugins in HOMEBREW_PREFIX/lib/gstreamer-0.10 instead of
    # HOMEBREW_PREFIX/Cellar/gstreamer/0.10/lib/gstreamer-0.10, so we'll find
    # plugins installed by other packages without setting GST_PLUGIN_PATH in
    # the environment.
    inreplace "configure", 'PLUGINDIR="$full_var"',
      "PLUGINDIR=\"#{HOMEBREW_PREFIX}/lib/gstreamer-0.10\""

    ENV.append "CFLAGS", "-funroll-loops -fstrict-aliasing -fno-common"

    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-introspection=no"
    system "make"
    system "make install"
  end
end

__END__
diff --git a/configure b/configure
index 0af896d..20e6576 100755
--- a/configure
+++ b/configure
@@ -21304,7 +21304,7 @@ fi
   fi
 
         flex_min_version=2.5.31
-  flex_version=`$FLEX_PATH --version | head -n 1 | sed 's/^.* //' | sed 's/[a-zA-Z]*$//' | cut -d' ' -f1`
+  flex_version=`$FLEX_PATH --version | head -n 1 | awk '{print $2'}`
   { $as_echo "$as_me:${as_lineno-$LINENO}: checking flex version $flex_version >= $flex_min_version" >&5
 $as_echo_n "checking flex version $flex_version >= $flex_min_version... " >&6; }
   if perl -w <<EOF
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
