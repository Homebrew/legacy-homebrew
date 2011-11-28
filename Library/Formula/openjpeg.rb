require 'formula'

class Openjpeg < Formula
  homepage 'http://www.openjpeg.org/'
  url 'http://openjpeg.googlecode.com/files/openjpeg_v1_4_sources_r697.tgz'
  version '1.4'
  md5 '7870bb84e810dec63fcf3b712ebb93db'

  head 'http://openjpeg.googlecode.com/svn/trunk/'

  depends_on 'cmake' => :build
  depends_on 'little-cms' => :optional
  depends_on 'libtiff'

  def patches
    # libpng 1.5 no longer #includes zlib.h, so add it to the relevant file
    # see http://code.google.com/p/openjpeg/issues/detail?id=83
    DATA
  end

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end

__END__
diff --git a/codec/convert.c b/codec/convert.c
index 25e715b..2d96971 100644
--- a/codec/convert.c
+++ b/codec/convert.c
@@ -48,6 +48,7 @@
 #include "../libs/png/png.h"
 #else
 #include <png.h>
+#include <zlib.h>
 #endif /* _WIN32 */
 #endif /* HAVE_LIBPNG */
 

