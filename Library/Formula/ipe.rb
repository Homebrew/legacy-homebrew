require 'formula'

class Ipe < Formula
  homepage 'http://ipe7.sourceforge.net'
  url 'http://sourceforge.net/projects/ipe7/files/ipe/7.1.0/ipe-7.1.3-src.tar.gz'
  sha1 '7999a85d902fbe3952664dea86c2c0a1aaed40d6'

  depends_on 'pkg-config' => :build
  depends_on 'makeicns' => :build
  depends_on 'lua'
  depends_on 'qt'
  depends_on :x11

  # configure library paths using pkg-config
  # because ipe assumes that Qt and other libs are installed in
  # some fixed default paths (and homebrew does not agree)
  # reported upstream:
  # https://sourceforge.net/apps/mantisbt/ipe7/view.php?id=105

  # TODO: clean up this patch; upstream doesn't want to carry it.
  # Also, we will always have pkg-config installed, so we don't need
  # the patch to handle the case where it isn't.
  # Recommend we take upstream's recommendation and set ENV vars for
  # the paths to override those in configure.
  # @adamv
  def patches; DATA; end

  fails_with :clang do
    build 318
    cause <<-EOS.undent
      IPE should be compiled with the same flags as Qt, which uses LLVM.
      ipeui_common.cpp:1: error: bad value (native) for -march= switch
    EOS
  end

  def install
    cd 'src' do
      system "make", "IPEPREFIX=#{prefix}"
      ENV.j1 # Parallel install fails
      system "make", "IPEPREFIX=#{prefix}", "install"
    end
  end
end

__END__
--- a/src/config.mak	2012-01-15 13:19:25.000000000 +0100
+++ b/src/config.mak	2012-04-01 15:15:07.000000000 +0200
@@ -39,6 +39,7 @@
 # directly.  You don't have to worry about the UI libraries you
 # haven't selected above.
 #
+
 ZLIB_CFLAGS   ?=
 ZLIB_LIBS     ?= -lz
 FREETYPE_CFLAGS ?= $(shell pkg-config --cflags freetype2)
@@ -58,6 +59,7 @@
 GTK_LIBS      ?= $(shell pkg-config --libs gtk+-2.0)
 QT_CFLAGS     ?= $(shell pkg-config --cflags QtGui QtCore)
 QT_LIBS	      ?= $(shell pkg-config --libs QtGui QtCore)
+
 #
 # MOC is the Qt meta-object compiler.  On Debian/Ubuntu, it is
 # installed as "moc-qt4" to resolve the name conflict with Qt3's
@@ -69,25 +71,49 @@
 #
 else
 #
-# Settings for Mac OS 10.6
+# Settings for Mac OS 10.6 and 10.7
+#
+# Use pkg-config if available (typically installed by homebrew or macports)
+#
+HAVE_PKG_CONFIG=$(shell which pkg-config > /dev/null && echo 1)
 #
 CONFIG     += x86_64
 ZLIB_CFLAGS   ?=
 ZLIB_LIBS     ?= -lz
-FREETYPE_CFLAGS ?= -I/usr/X11/include/freetype2 -I/usr/X11/include
-FREETYPE_LIBS ?= -L/usr/X11/lib -lfreetype
-CAIRO_CFLAGS  ?= -I/usr/X11/include/cairo -I/usr/X11/include/pixman-1 \
-	 -I/usr/X11/include/freetype2 -I/usr/X11/include \
-	 -I/usr/X11/include/libpng12
-CAIRO_LIBS ?= -L/usr/X11/lib -lcairo
-LUA_CFLAGS ?= -I/usr/local/include
-LUA_LIBS   ?= -L/usr/local/lib -llua5.1 -lm
-QT_CFLAGS  ?= -I/Library/Frameworks/QtCore.framework/Versions/4/Headers \
-	      -I/Library/Frameworks/QtGui.framework/Versions/4/Headers
-QT_LIBS    ?= -F/Library/Frameworks -L/Library/Frameworks \
-	      -framework QtCore -framework ApplicationServices \
-	      -framework QtGui -framework AppKit -framework Cocoa -lz -lm
-MOC	   ?= moc
+ifeq "$(HAVE_PKG_CONFIG)" "1"
+  FREETYPE_CFLAGS ?= $(shell pkg-config --cflags freetype2)
+  FREETYPE_LIBS ?= $(shell pkg-config --libs freetype2)
+  CAIRO_CFLAGS  ?= $(shell pkg-config --cflags cairo)
+  CAIRO_LIBS    ?= $(shell pkg-config --libs cairo)
+  # The lua package might be called "lua" or "lua5.1"
+  luatest = $(shell pkg-config --modversion --silence-errors lua)
+  ifneq "$(luatest)" ""
+    LUA_CFLAGS  ?= $(shell pkg-config --cflags lua)
+    LUA_LIBS    ?= $(shell pkg-config --libs lua)
+  else
+    LUA_CFLAGS  ?= $(shell pkg-config --cflags lua5.1)
+    LUA_LIBS    ?= $(shell pkg-config --libs lua5.1)
+  endif
+  GTK_CFLAGS    ?= $(shell pkg-config --cflags gtk+-2.0)
+  GTK_LIBS      ?= $(shell pkg-config --libs gtk+-2.0)
+  QT_CFLAGS     ?= $(shell pkg-config --cflags QtGui QtCore)
+  QT_LIBS	      ?= $(shell pkg-config --libs QtGui QtCore)
+else
+  FREETYPE_CFLAGS ?= -I/usr/X11/include/freetype2 -I/usr/X11/include
+  FREETYPE_LIBS ?= -L/usr/X11/lib -lfreetype
+  CAIRO_CFLAGS  ?= -I/usr/X11/include/cairo -I/usr/X11/include/pixman-1 \
+	   -I/usr/X11/include/freetype2 -I/usr/X11/include \
+	   -I/usr/X11/include/libpng12
+  CAIRO_LIBS ?= -L/usr/X11/lib -lcairo
+  LUA_CFLAGS ?= -I/usr/local/include
+  LUA_LIBS   ?= -L/usr/local/lib -llua5.1 -lm
+  QT_CFLAGS  ?= -I/Library/Frameworks/QtCore.framework/Versions/4/Headers \
+		-I/Library/Frameworks/QtGui.framework/Versions/4/Headers
+  QT_LIBS    ?= -F/Library/Frameworks -L/Library/Frameworks \
+		-framework QtCore -framework ApplicationServices \
+		-framework QtGui -framework AppKit -framework Cocoa -lz -lm
+endif
+MOC           ?= moc
 endif
 #
 # --------------------------------------------------------------------
