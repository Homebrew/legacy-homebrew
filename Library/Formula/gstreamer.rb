require 'formula'

class Gstreamer < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-0.10.36.tar.bz2'
  sha256 'e556a529e0a8cf1cd0afd0cab2af5488c9524e7c3f409de29b5d82bb41ae7a30'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'

  # Fix sed version detection for 10.8
  # Reported and fixed upstream:
  # https://bugzilla.gnome.org/show_bug.cgi?id=680428
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
