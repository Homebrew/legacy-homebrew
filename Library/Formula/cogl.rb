require "formula"

class Cogl < Formula
  homepage "http://developer.gnome.org/cogl/"
  url "http://ftp.gnome.org/pub/gnome/sources/cogl/1.18/cogl-1.18.2.tar.xz"
  sha256 "9278e519d5480eb0379efd48db024e8fdbf93f01dff48a7e756b85b508a863aa"

  bottle do
    sha1 "6ed57026e1e5f8a7ae7ca4d6191fcdfa496d7b9f" => :mavericks
    sha1 "a064bf230c3188142a2c8d5d1d6031f164a1507f" => :mountain_lion
    sha1 "994fa2392d984d6a7a6885d7ed705231c8fd5f71" => :lion
  end

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

  # Lion's grep fails, which later results in compilation failures:
  # libtool: link: /usr/bin/grep -E -e [really long regexp] ".libs/libcogl.exp" > ".libs/libcogl.expT"
  # grep: Regular expression too big
  resource "grep" do
    url "http://ftpmirror.gnu.org/grep/grep-2.20.tar.xz"
    mirror "https://ftp.gnu.org/gnu/grep/grep-2.20.tar.xz"
    sha256 "f0af452bc0d09464b6d089b6d56a0a3c16672e9ed9118fbe37b0b6aeaf069a65"
  end if MacOS.version == :lion

  # Patch from MacPorts, reported upstream at https://bugzilla.gnome.org/show_bug.cgi?id=708825
  # https://trac.macports.org/browser/trunk/dports/graphics/cogl/files/patch-clock_gettime.diff
  patch :DATA

  def install
    resource("grep").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--disable-nls",
                            "--prefix=#{buildpath}/grep"
      system "make", "install"
      ENV["GREP"] = "#{buildpath}/grep/bin/grep"
    end if MacOS.version == :lion

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
