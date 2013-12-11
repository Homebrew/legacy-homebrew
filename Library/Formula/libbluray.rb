require 'formula'

class Libbluray < Formula
  homepage 'http://www.videolan.org/developers/libbluray.html'
  url 'ftp://ftp.videolan.org/pub/videolan/libbluray/0.4.0/libbluray-0.4.0.tar.bz2'
  sha1 '39984aae77efde2e0917ed7e183ebf612813d7f3'

  head do
    url 'git://git.videolan.org/libbluray.git'

    depends_on :automake => :build
    depends_on :autoconf => :build
    depends_on :libtool  => :build
  end

  depends_on 'pkg-config' => :build
  depends_on :freetype => :recommended

  # Upstream patch for freetype 2.5.1+
  def patches; DATA; end

  def install
    ENV.libxml2

    system "./bootstrap" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end

__END__
diff --git a/src/libbluray/decoders/textst_render.c b/src/libbluray/decoders/textst_render.c
index 780b640..ffcb1bd 100644
--- a/src/libbluray/decoders/textst_render.c
+++ b/src/libbluray/decoders/textst_render.c
@@ -30,7 +30,7 @@
 #ifdef HAVE_FT2
 #include <ft2build.h>
 #include FT_FREETYPE_H
-#include <freetype/ftsynth.h>
+#include FT_SYNTHESIS_H
 #endif
 
 #include "textst_render.h"

