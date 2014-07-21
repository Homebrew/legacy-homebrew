require "formula"

class Cogl < Formula
  homepage "http://developer.gnome.org/cogl/"
  url "http://ftp.gnome.org/pub/gnome/sources/cogl/1.14/cogl-1.14.0.tar.xz"
  sha256 "276e8c9f5ff0fcd57c1eaf74cc245f41ad469a95a18ac831fac2d5960baa5ae8"

  head do
    url "git://git.gnome.org/cogl"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "without-x", "Build without X11 support"

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "pango"
  depends_on :x11 => "2.5.1" if build.with? "x"
  depends_on "gobject-introspection"

  # Patch from MacPorts, reported upstream at https://bugzilla.gnome.org/show_bug.cgi?id=708825
  # https://trac.macports.org/browser/trunk/dports/graphics/cogl/files/patch-clock_gettime.diff
  patch :DATA

  def install
    system "./autogen.sh" if build.head?
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-cogl-pango=yes
      --enable-introspection=yes
    ]
    args << "--without-x" if build.without? "x"
    system "./configure", *args
    system "make install"
  end
end
__END__
diff --git a/cogl/winsys/cogl-winsys-glx.c b/cogl/winsys/cogl-winsys-glx.c
--- a/cogl/winsys/cogl-winsys-glx.c
+++ b/cogl/winsys/cogl-winsys-glx.c
@@ -56,7 +56,26 @@
 #include <sys/stat.h>
 #include <sys/time.h>
 #include <fcntl.h>
+
+#ifdef __MACH__
+#include <mach/mach_time.h>
+#define CLOCK_REALTIME 0
+#define CLOCK_MONOTONIC 0
+static int
+clock_gettime(int clk_id, struct timespec *t){
+    mach_timebase_info_data_t timebase;
+    mach_timebase_info(&timebase);
+    uint64_t time;
+    time = mach_absolute_time();
+    double nseconds = ((double)time * (double)timebase.numer)/((double)timebase.denom);
+    double seconds = ((double)time * (double)timebase.numer)/((double)timebase.denom * 1e9);
+    t->tv_sec = seconds;
+    t->tv_nsec = nseconds;
+    return 0;
+}
+#else
 #include <time.h>
+#endif

 #include <glib/gi18n-lib.h>
