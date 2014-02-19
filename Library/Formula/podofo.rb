require 'formula'

class Podofo < Formula
  homepage 'http://podofo.sourceforge.net'
  url 'http://downloads.sourceforge.net/podofo/podofo-0.9.2.tar.gz'
  sha1 '8a6e27e17e0ed9f12e1a999cff66eae8eb97a4bc'

  depends_on 'cmake' => :build
  depends_on :libpng
  depends_on :freetype
  depends_on :fontconfig
  depends_on 'jpeg'
  depends_on 'libtiff'

  def patches
    # FindFREEType.cmake has dos line endings, have to
    # replace dos line endings before applying the patch
    inreplace "cmake/modules/FindFREEType.cmake", "\r\n", "\n"

    # the first two patches fix missing includes (didn't compile in Mavericks)
    # the third patch is needed to make podofo work with freetype 2.5.1
    return DATA
  end

  def install
    mkdir 'build' do
      # Build shared to simplify linking for other programs.
      system "cmake", "..",
                      "-DPODOFO_BUILD_SHARED:BOOL=TRUE",
                      *std_cmake_args
      system "make install"
    end
  end
end

__END__
diff --git a/src/base/PdfInputDevice.h b/src/base/PdfInputDevice.h
index ade4ff2..a804e8a 100644
--- a/src/base/PdfInputDevice.h
+++ b/src/base/PdfInputDevice.h
@@ -22,6 +22,7 @@
 #define _PDF_INPUT_DEVICE_H_

 #include <istream>
+#include <ios>

 #include "PdfDefines.h"
 #include "PdfLocale.h"

diff --git a/src/base/PdfLocale.h b/src/base/PdfLocale.h
index 726d5cf..7268365 100644
--- a/src/base/PdfLocale.h
+++ b/src/base/PdfLocale.h
@@ -1,7 +1,7 @@
 #ifndef PODOFO_PDFLOCALE_H
 #define PODOFO_PDFLOCALE_H
 
-namespace std { class ios_base; };
+#include <ios>
 
 namespace PoDoFo {

diff --git a/cmake/modules/FindFREETYPE.cmake b/cmake/modules/FindFREETYPE.cmake
index ce0e3e9..5efc560 100644
--- a/cmake/modules/FindFREETYPE.cmake
+++ b/cmake/modules/FindFREETYPE.cmake
@@ -13,13 +13,13 @@
 SET(FREETYPE_FIND_QUIETLY 1)
 
 FIND_PATH(FREETYPE_INCLUDE_DIR_FT2BUILD ft2build.h
-  /usr/include/
-  /usr/local/include/
-  /usr/X11/include/
+  /usr/include/freetype2
+  /usr/local/include/freetype2
+  /usr/X11/include/freetype2
   NO_CMAKE_SYSTEM_PATH
 )
 
-FIND_PATH(FREETYPE_INCLUDE_DIR_FTHEADER freetype/config/ftheader.h
+FIND_PATH(FREETYPE_INCLUDE_DIR_FTHEADER config/ftheader.h
   /usr/include/freetype2
   /usr/local/include/freetype2
   /usr/X11/include/freetype2
