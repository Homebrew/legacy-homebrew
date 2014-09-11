require "formula"

class Mal4s < Formula
  homepage "https://github.com/secure411dotorg/mal4s/"
  url "https://service.dissectcyber.com/mal4s/mal4s-1.1.2.tar.gz"
  sha1 "a99b2ffb9d2e1395c8f38a27108611611ca925df"

  head "https://github.com/secure411dotorg/mal4s.git"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "glm" => :build
  depends_on "boost"
  depends_on "glew"
  depends_on "jpeg"
  depends_on "pcre"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "freetype"
  depends_on :x11 => :optional

  needs :cxx11

  stable do
    # fix compile failure.
    # https://github.com/secure411dotorg/mal4s/pull/38
    patch :DATA
  end

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--without-x" if build.without? "x11"
    system "autoreconf", "-f", "-i"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/mal4s", "--stop-at-end", "#{share}/mal4s/sample--newns.mal4s"
  end
end

__END__
diff --git a/src/gource_settings.cpp b/src/gource_settings.cpp
index 0401d7a..453bad3 100644
--- a/src/gource_settings.cpp
+++ b/src/gource_settings.cpp
@@ -25,6 +25,7 @@
 
 #include "core/utf8/utf8.h"
 #include <time.h>
+#include <iostream>
 
 /*
 #include "formats/hg.h"
