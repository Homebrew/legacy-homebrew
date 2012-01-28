require 'formula'

def poppler_has_qt4?
  poppler = Formula.factory('poppler')
  not Dir[poppler.include + '**/*qt4.h'].empty?
end

class Diffpdf < Formula
  homepage 'http://www.qtrac.eu/diffpdf.html'
  url 'http://www.qtrac.eu/diffpdf-1.8.0.tar.gz'
  md5 'bfede6ebd3cc4993c50aec5b90628807'

  depends_on 'qt'
  depends_on 'poppler'

  def patches
    # Fix library and header search paths.
    DATA
  end

  def install
    if poppler_has_qt4?
      # Generate makefile and disable .app creation
      system 'qmake -spec macx-g++ CONFIG-=app_bundle'
      system 'make'

      bin.install 'diffpdf'
      man1.install 'diffpdf.1'
    else
      onoe <<-EOS.undent
        Could not locate header files for poppler-qt4. This probably means that Poppler
        was not installed with support for Qt. Try reinstalling Poppler using the
        `--with-qt4` option.
      EOS

      exit 1
    end
  end
end

__END__

The location of Poppler library/include paths is hardcoded in the project file
which causes builds to fail if Homebrew is not installed to /usr/local.

diff --git a/diffpdf.pro b/diffpdf.pro
index 1566ed7..7d37a3d 100644
--- a/diffpdf.pro
+++ b/diffpdf.pro
@@ -17,15 +17,6 @@ HEADERS	    += sequence_matcher.hpp
 SOURCES     += sequence_matcher.cpp
 SOURCES     += main.cpp
 RESOURCES   += resources.qrc
-LIBS	    += -lpoppler-qt4
-exists($(HOME)/opt/poppler018/) {
-    message(Using locally built Poppler library)
-    INCLUDEPATH += $(HOME)/opt/poppler018/include/poppler/qt4
-    LIBS += -Wl,-rpath -Wl,$(HOME)/opt/poppler018/lib -Wl,-L$(HOME)/opt/poppler018/lib
-} else {
-    exists(/usr/include/poppler/qt4) {
-	INCLUDEPATH += /usr/include/poppler/qt4
-    } else {
-	INCLUDEPATH += /usr/local/include/poppler/qt4
-    }
-}
+
+LIBS       += -L$$quote(HOMEBREW_PREFIX/lib) -lpoppler-qt4
+INCLUDEPATH += $$quote(HOMEBREW_PREFIX/include/poppler/qt4)
