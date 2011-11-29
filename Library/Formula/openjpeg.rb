require 'formula'

class Openjpeg < Formula
  homepage 'http://www.openjpeg.org/'
  url 'http://openjpeg.googlecode.com/files/openjpeg_v1_4_sources_r697.tgz'
  version '1.4'
  md5 '7870bb84e810dec63fcf3b712ebb93db'

  head 'http://openjpeg.googlecode.com/svn/trunk/'

  # Head can have an optional dep on little-cms2 for which there is a pull request,
  # but it's unlikely to be pulled as there is a policy against multiple versions.
  # If the user adds little-cms2 themselves, installing head will find and use it,
  # without any changes to the formula.
  depends_on 'cmake' => :build
  depends_on 'libtiff'
  depends_on 'little-cms' => :optional

  def patches
    # libpng 1.5 no longer #includes zlib.h, so add it to the relevant file
    # see http://code.google.com/p/openjpeg/issues/detail?id=83
    DATA
  end

  def install

    # Fixes missing symbols, as Apple removed zlib.h from png.h on Lion.
    if MacOS.lion? and not ARGV.build_head?
      inreplace 'codec/convert.c', '#include <png.h>',
                                   "#include <png.h>\n#include <zlib.h>"
    end

    Dir.mkdir 'macbuild'
    Dir.chdir 'macbuild' do
      system "cmake #{std_cmake_parameters} .."
      system "make install"
    end
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
 

