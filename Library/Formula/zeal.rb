class Zeal < Formula
  desc "Zeal is a simple offline documentation browser inspired by Dash."
  homepage "http://zealdocs.org/"
  url "https://github.com/zealdocs/zeal/archive/v0.1.1.tar.gz"
  sha256 "f4e959f9bc66a6e350ee8a33d34695379633432d103db9776c0c7a76cbc5a9d6"
  head "https://github.com/zealdocs/zeal.git"

  depends_on "qt5"
  depends_on "libarchive"

  patch :DATA

  def install
    qt5 = Formula["qt5"]
    ENV.append "CFLAGS", "-I#{qt5.installed_prefix}/include -I#{HOMEBREW_PREFIX}/opt/libarchive/include"
    ENV.append "CXXFLAGS", "-I#{qt5.installed_prefix}/include -I#{HOMEBREW_PREFIX}/opt/libarchive/include"
    ENV.append "LDFLAGS", "-L#{qt5.installed_prefix}/lib -L#{HOMEBREW_PREFIX}/opt/libarchive/lib -larchive"

    system "#{qt5.installed_prefix}/bin/qmake"
    system "make"
    system "#{qt5.installed_prefix}/bin/macdeployqt", "bin/Zeal.app"
    prefix.install "bin/Zeal.app"
    (bin/"zeal").write("#! /bin/sh\n#{prefix}/Zeal.app/Contents/MacOS/Zeal \"$@\"\n")
  end

  test do
    system "zeal", "-h"
  end
end
__END__
diff --git a/src/src.pro b/src/src.pro
index 8f2c721..22623bb 100644
--- a/src/src.pro
+++ b/src/src.pro
@@ -78,3 +78,8 @@ MOC_DIR = $$BUILD_ROOT/.moc
 OBJECTS_DIR = $$BUILD_ROOT/.obj
 RCC_DIR = $$BUILD_ROOT/.rcc
 UI_DIR = $$BUILD_ROOT/.ui
+QMAKE_CFLAGS += $$(CFLAGS)
+QMAKE_CXXFLAGS += $$(CXXFLAGS)
+QMAKE_LFLAGS += $$(LDFLAGS)
+macx:INCLUDEPATH += /usr/local/opt/libarchive/include
+macx:DEPENDPATH += /usr/local/opt/libarchive/include
