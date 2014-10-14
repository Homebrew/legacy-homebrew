require 'formula'

class Ipe < Formula
  homepage 'http://ipe7.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/ipe7/ipe/7.1/ipe-7.1.5-src.tar.gz'
  mirror 'https://raw.githubusercontent.com/DomT4/LibreMirror/master/Ipe/ipe-7.1.5-src.tar.gz'
  sha1 'a30257e3026f936d550cf950f6dfcc980cf42bf4'

  depends_on 'pkg-config' => :build
  depends_on 'makeicns' => :build
  depends_on 'lua'
  depends_on 'qt'
  depends_on 'cairo'
  depends_on 'jpeg-turbo'
  depends_on 'freetype'

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
  patch :DATA

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
--- a/src/config.mak	2014-05-07 03:28:31.000000000 -0400
+++ b/src/config.mak	2014-05-14 10:09:51.000000000 -0400
@@ -61,28 +61,45 @@
 #
 else
 #
-# Settings for Mac OS 10.6
+# Settings for Mac OS 10.9
+#
+# Use pkg-config if available (typically installed by homebrew or macports)
+#
+HAVE_PKG_CONFIG=$(shell which pkg-config > /dev/null && echo 1)
 #
 CONFIG     += x86_64
 DL_LIBS       ?= -ldl
 ZLIB_CFLAGS   ?=
 ZLIB_LIBS     ?= -lz
+# The jpeg-turbo package doesn't seem to have a pkg-config file
 JPEG_CFLAGS   ?= 
 JPEG_LIBS     ?= -lturbojpeg
-FREETYPE_CFLAGS ?= -I/usr/X11/include/freetype2 -I/usr/X11/include
-FREETYPE_LIBS ?= -L/usr/X11/lib -lfreetype
-CAIRO_CFLAGS  ?= -I/usr/X11/include/cairo -I/usr/X11/include/pixman-1 \
-	 -I/usr/X11/include/freetype2 -I/usr/X11/include \
-	 -I/usr/X11/include/libpng12
-CAIRO_LIBS ?= -L/usr/X11/lib -lcairo
-LUA_CFLAGS ?= -I/usr/local/include
-LUA_LIBS   ?= -L/usr/local/lib -llua52 -lm
-QT_CFLAGS  ?= -I/Library/Frameworks/QtCore.framework/Versions/4/Headers \
-	      -I/Library/Frameworks/QtGui.framework/Versions/4/Headers
-QT_LIBS    ?= -F/Library/Frameworks -L/Library/Frameworks \
-	      -framework QtCore -framework ApplicationServices \
-	      -framework QtGui -framework AppKit -framework Cocoa -lz -lm
-MOC	   ?= moc
+LUA_CFLAGS ?=
+LUA_LIBS   ?= -llua -lm
+ifeq "$(HAVE_PKG_CONFIG)" "1"
+  FREETYPE_CFLAGS ?= $(shell pkg-config --cflags freetype2)
+  FREETYPE_LIBS   ?= $(shell pkg-config --libs freetype2)
+  CAIRO_CFLAGS ?= $(shell pkg-config --cflags cairo)
+  CAIRO_LIBS   ?= $(shell pkg-config --libs cairo)
+  GTK_CFLAGS ?= $(shell pkg-config --cflags gtk+-2.0)
+  GTK_LIBS   ?= $(shell pkg-config --libs gtk+-2.0)
+  QT_CFLAGS ?= $(shell pkg-config --cflags QtGui QtCore)
+  QT_LIBS	?= $(shell pkg-config --libs QtGui QtCore)
+else
+  FREETYPE_CFLAGS ?= -I/usr/X11/include/freetype2 -I/usr/X11/include
+  FREETYPE_LIBS ?= -L/usr/X11/lib -lfreetype
+  CAIRO_CFLAGS  ?= -I/usr/X11/include/cairo -I/usr/X11/include/pixman-1 \
+	   -I/usr/X11/include/freetype2 -I/usr/X11/include \
+	   -I/usr/X11/include/libpng12
+  CAIRO_LIBS ?= -L/usr/X11/lib -lcairo
+  QT_CFLAGS  ?= -I/Library/Frameworks/QtCore.framework/Versions/4/Headers \
+		-I/Library/Frameworks/QtGui.framework/Versions/4/Headers
+  QT_LIBS    ?= -F/Library/Frameworks -L/Library/Frameworks \
+		-framework QtCore -framework ApplicationServices \
+		-framework QtGui -framework AppKit -framework Cocoa -lz -lm
+endif
+
+MOC           ?= moc
 endif
 #
 # --------------------------------------------------------------------
