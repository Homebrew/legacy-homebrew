require 'formula'

class Ipe < Formula
  url 'http://sourceforge.net/projects/ipe7/files/ipe/ipe-7.0.14-src.tar.gz'
  homepage 'http://ipe7.sourceforge.net'
  md5 '13b1790813304ac888402d9c6c40a6ec'

  depends_on 'qt'
  depends_on 'cairo'
  depends_on 'lua'
  # build dependencies
  depends_on 'makeicns'
  depends_on 'pkg-config'

  def install
    system "cd src/; make install IPEPREFIX=/usr/local"
    #system "cd src/; make install"
  end

  def patches
    { :p0 => DATA }
  end
end

__END__
--- src/common.mak.orig	2011-08-20 16:51:52.000000000 +0200
+++ src/common.mak	2011-08-20 16:53:28.000000000 +0200
@@ -99,7 +99,7 @@
   CXXFLAGS	+= -g -O2
   ifdef MACOS
     DLL_LDFLAGS	+= -dynamiclib 
-    soname      = -Wl,-dylib_install_name,lib$1.so.$(IPEVERS)
+    soname      = -Wl,-dylib_install_name,$(IPELIBDIR)/lib$1.so.$(IPEVERS)
   else	
     DLL_LDFLAGS	+= -shared 
     soname      = -Wl,-soname,lib$1.so.$(IPEVERS)
--- src/config.mak.orig	2011-02-16 02:37:06.000000000 +0100
+++ src/config.mak	2011-08-20 16:56:57.000000000 +0200
@@ -52,12 +52,9 @@
 CONFIG     += x86_64
 LUA_CFLAGS = $(shell pkg-config --cflags lua)
 LUA_LIBS   = $(shell pkg-config --libs lua)
-QT_CFLAGS  = -I/Library/Frameworks/QtCore.framework/Versions/4/Headers \
-	     -I/Library/Frameworks/QtGui.framework/Versions/4/Headers
-QT_LIBS    = -F/Library/Frameworks -L/Library/Frameworks \
-	     -framework QtCore -framework ApplicationServices \
-	     -framework QtGui -framework AppKit -framework Cocoa -lz -lm
-MOC	   = moc
+QT_CFLAGS  ?= $(shell pkg-config --cflags QtGui QtCore)
+QT_LIBS           ?= $(shell pkg-config --libs QtGui QtCore)
+MOC       ?= moc
 endif
 #
 # --------------------------------------------------------------------
