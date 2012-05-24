require 'formula'

class PopplerQt4 < Requirement
  def satisfied?
    poppler = Tab.for_formula 'poppler'
    poppler.installed_with? '--with-qt4'
  end

  def fatal?
    true
  end

  def message; <<-EOS.undent
    DiffPDF requires the Poppler-Qt4 bindings but Poppler was not installed
    with support for Qt. Please reinstall Poppler using the `--with-qt4`
    option.
    EOS
  end
end

class Diffpdf < Formula
  homepage 'http://www.qtrac.eu/diffpdf.html'
  url 'http://www.qtrac.eu/diffpdf-2.0.0.tar.gz'
  md5 '88b5346cdbfb024a9ad751c7e9a0eee4'

  depends_on 'qt'
  depends_on 'poppler'
  depends_on PopplerQt4.new

  # The location of Poppler library/include paths is hardcoded in the project file
  # which causes builds to fail if Homebrew is not installed to /usr/local.
  def patches
    DATA
  end

  def install
    # The 2.0 sources shipped without translation files. Generate them so that
    # compilation does not fail.
    system 'lrelease', 'diffpdf.pro'
    # Generate makefile and disable .app creation
    system 'qmake -spec macx-g++ CONFIG-=app_bundle'
    system 'make'

    bin.install 'diffpdf'
    man1.install 'diffpdf.1'
  end
end

__END__

diff --git a/diffpdf.pro b/diffpdf.pro
index 8b511b6..2079247 100644
--- a/diffpdf.pro
+++ b/diffpdf.pro
@@ -31,36 +31,7 @@ LIBS	     += -lpoppler-qt4
 win32 {
     CONFIG += release
 }
-exists($(HOME)/opt/poppler018/) {
-    message(Using locally built Poppler library)
-    INCLUDEPATH += $(HOME)/opt/poppler018/include/poppler/cpp
-    INCLUDEPATH += $(HOME)/opt/poppler018/include/poppler/qt4
-    LIBS += -Wl,-rpath -Wl,$(HOME)/opt/poppler018/lib -Wl,-L$(HOME)/opt/poppler018/lib
-} else {
-    exists(/poppler_lib) {
-	message(Using locally built Poppler library on Windows)
-	INCLUDEPATH += /c/poppler_lib/include/poppler/cpp
-	INCLUDEPATH += /c/poppler_lib/include/poppler/qt4
-	LIBS += -Wl,-rpath -Wl,/c/poppler_lib/bin -Wl,-L/c/poppler_lib/bin
-    } else {
-	exists(/usr/include/poppler/qt4) {
-	    INCLUDEPATH += /usr/include/poppler/cpp
-	    INCLUDEPATH += /usr/include/poppler/qt4
-	} else {
-	    INCLUDEPATH += /usr/local/include/poppler/cpp
-	    INCLUDEPATH += /usr/local/include/poppler/qt4
-	}
-    }
-}
-#exists($(HOME)/opt/podofo09/) {
-#    message(Using locally built PoDoFo library)
-#    INCLUDEPATH += $(HOME)/opt/podofo09/include/poppler/cpp
-#    INCLUDEPATH += $(HOME)/opt/podofo09/include/poppler/qt4
-#    LIBS += -Wl,-rpath -Wl,$(HOME)/opt/podofo09/lib64 -Wl,-L$(HOME)/opt/podofo09/lib64
-#} else {
-#    exists(/usr/include/podofo) {
-#	INCLUDEPATH += /usr/include/podofo
-#    } else {
-#	INCLUDEPATH += /usr/local/include/podofo
-#    }
-#}
+
+LIBS       += -L$$quote(HOMEBREW_PREFIX/lib) -lpoppler-qt4
+INCLUDEPATH += $$quote(HOMEBREW_PREFIX/include/poppler/cpp)
+INCLUDEPATH += $$quote(HOMEBREW_PREFIX/include/poppler/qt4)
