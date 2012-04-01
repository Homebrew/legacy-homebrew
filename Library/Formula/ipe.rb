require 'formula'

class Ipe < Formula
  url 'http://downloads.sourceforge.net/project/ipe7/ipe/ipe-7.0.14-src.tar.gz'
  homepage 'http://ipe7.sourceforge.net/'
  md5 '13b1790813304ac888402d9c6c40a6ec'

  depends_on "pkg-config"
  depends_on "lua"
  depends_on "qt"
  depends_on "cairo" if MacOS.leopard?

  def patches
      # Patch to config.mak locates qt frameworks
      # Patch to common.mak fixes ipe lib path
      DATA
  end

  def install
    ENV["IPEPREFIX"] = prefix
    ENV["QT_FRAMEWORK"] = "#{HOMEBREW_PREFIX}/lib"
    system "make -C src install"
  end
end

__END__
diff --git a/src/config.mak b/src/config.mak
index 7bf7daa..23c980d 100644
--- a/src/config.mak
+++ b/src/config.mak
@@ -52,9 +52,9 @@ else
 CONFIG     += x86_64
 LUA_CFLAGS = $(shell pkg-config --cflags lua)
 LUA_LIBS   = $(shell pkg-config --libs lua)
-QT_CFLAGS  = -I/Library/Frameworks/QtCore.framework/Versions/4/Headers \
-	     -I/Library/Frameworks/QtGui.framework/Versions/4/Headers
-QT_LIBS    = -F/Library/Frameworks -L/Library/Frameworks \
+QT_CFLAGS  = -I$(QT_FRAMEWORK)/QtCore.framework/Versions/4/Headers \
+	     -I$(QT_FRAMEWORK)/QtGui.framework/Versions/4/Headers -F$(QT_FRAMEWORK)
+QT_LIBS    = -F$(QT_FRAMEWORK) -L$(QT_FRAMEWORK) \
 	     -framework QtCore -framework ApplicationServices \
 	     -framework QtGui -framework AppKit -framework Cocoa -lz -lm
 MOC	   = moc

diff --git a/src/common.mak b/src/common.mak
--- a/src/common.mak	2011-02-03 03:15:03.000000000 +0100
+++ b/src/common.mak	2011-02-03 03:16:40.000000000 +0100
@@ -99,7 +99,7 @@
   CXXFLAGS	+= -g -O2
   ifdef MACOS
     DLL_LDFLAGS	+= -dynamiclib 
-    soname      = -Wl,-dylib_install_name,lib$1.so.$(IPEVERS)
+    soname      = -Wl,-dylib_install_name,$(IPELIBDIR)/lib$1.so.$(IPEVERS)
   else	
     DLL_LDFLAGS	+= -shared 
     soname      = -Wl,-soname,lib$1.so.$(IPEVERS)

