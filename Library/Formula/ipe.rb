require 'formula'

class Ipe < Formula
  url 'http://sourceforge.net/projects/ipe7/files/ipe/7.1.0/ipe-7.1.1-src.tar.gz'
  homepage 'http://ipe7.sourceforge.net'
  md5 '0b15be5a0c12274c36e2805c0da94e27'

  depends_on 'qt'
  depends_on 'lua'
  depends_on 'makeicns' => :build
  depends_on 'pkg-config' => :build

  def install
    Dir.chdir 'src' do
      system "make IPEPREFIX=#{prefix} install"
    end
  end

  def patches
    { :p0 => DATA }
  end
end

__END__
--- src/config.mak	2011-09-06 22:01:44.000000000 +0200
+++ src/config.mak.orig	2011-09-22 10:13:18.000000000 +0200
@@ -81,12 +81,9 @@
 	 -I/usr/X11/include/libpng12
 CAIRO_LIBS ?= -L/usr/X11/lib -lcairo
 LUA_CFLAGS ?= -I/usr/local/include
-LUA_LIBS   ?= -L/usr/local/lib -llua5.1 -lm
-QT_CFLAGS  ?= -I/Library/Frameworks/QtCore.framework/Versions/4/Headers \
-	      -I/Library/Frameworks/QtGui.framework/Versions/4/Headers
-QT_LIBS    ?= -F/Library/Frameworks -L/Library/Frameworks \
-	      -framework QtCore -framework ApplicationServices \
-	      -framework QtGui -framework AppKit -framework Cocoa -lz -lm
+LUA_LIBS   ?= -L/usr/local/lib -llua -lm
+QT_CFLAGS  ?= $(shell pkg-config --cflags QtGui QtCore)
+QT_LIBS    ?= $(shell pkg-config --libs QtGui QtCore)
 MOC	   ?= moc
 endif
 #
