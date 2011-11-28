require 'formula'

class Babl < Formula
  url 'ftp://ftp.gimp.org/pub/babl/0.1/babl-0.1.6.tar.bz2'
  homepage 'http://www.gegl.org/babl/'
  md5 'dc960981a5ec5330fc1c177be9f59068'

  head 'git://git.gnome.org/babl'

  depends_on 'pkg-config' => :build

  def options
  [
    ["--universal", "Builds a universal binary"],
  ]
  end

  def patches
    # Fixes an error when compiling with clang
    # The fix was found on macports: https://trac.macports.org/browser/trunk/dports/graphics/babl/files/clang.patch
    { :p0 => DATA }
  end

  def install
    if ARGV.build_universal?
      ENV.universal_binary
      opoo 'Compilation may fail at babl-cpuaccel.c using gcc for a universal build' if ENV.compiler == :gcc
    end

    argv = ["--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"]

    system "./configure", *argv
    system "/usr/bin/make install"
  end
end

__END__
Index: extensions/sse-fixups.c
===================================================================
--- extensions/sse-fixups.c.orig 2011-06-28 20:01:39.000000000 -0700
+++ extensions/sse-fixups.c 2011-06-28 20:01:29.000000000 -0700
@@ -21,7 +21,7 @@
 
 #include "config.h"
 
-#if defined(__GNUC__) && (__GNUC__ >= 4) && defined(USE_SSE) && defined(USE_MMX)
+#if !defined(__clang__) && defined(__GNUC__) && (__GNUC__ >= 4) && defined(USE_SSE) && defined(USE_MMX)
 
 #include <stdint.h>
 #include <stdlib.h>
@@ -173,7 +173,7 @@
 int
 init (void)
 {
-#if defined(__GNUC__) && (__GNUC__ >= 4) && defined(USE_SSE) && defined(USE_MMX)
+#if !defined(__clang__) && defined(__GNUC__) && (__GNUC__ >= 4) && defined(USE_SSE) && defined(USE_MMX)
 
   Babl *rgbaF_linear = babl_format_new (
     babl_model ("RGBA"),
