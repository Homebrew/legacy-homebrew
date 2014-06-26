require 'formula'

class Imlib2 < Formula
  homepage 'http://sourceforge.net/projects/enlightenment/files/'
  url 'https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.4.6/imlib2-1.4.6.tar.bz2'
  sha1 '20e111d822074593e8d657ecf8aafe504e9e2967'
  revision 1

  option "without-x", "Build without X support"

  depends_on 'freetype'
  depends_on 'libpng' => :recommended
  depends_on :x11 if build.with? "x"
  depends_on 'pkg-config' => :build
  depends_on 'jpeg' => :recommended

  stable do
    patch :DATA
    patch :p0, :DATA
	end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-amd64=no
    ]
    args << "--without-x" if build.without? "x"

    system "./configure", *args
    system "make install"
  end

  test do
    system "#{bin}/imlib2_conv", "/usr/share/doc/cups/images/cups.png", "imlib2_test.png"
  end
end

__END__
diff --git a/src/bin/imlib2_view.c b/src/bin/imlib2_view.c
index 7a84211..ded57f8 100644
--- a/src/bin/imlib2_view.c
+++ b/src/bin/imlib2_view.c
@@ -5,6 +5,8 @@
 #include <X11/extensions/shape.h>
 #include <X11/Xatom.h>
 #include <X11/Xos.h>
+#define XK_LATIN1 1
+#include <X11/keysymdef.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
