require 'formula'

class Glfw < Formula
  url 'http://downloads.sourceforge.net/project/glfw/glfw/2.7.2/glfw-2.7.2.tar.bz2'
  homepage 'http://www.glfw.org/'
  md5 'bb4f33b43e40f8cd3015a653dca02ed1'

  def install
    ENV.prepend 'PREFIX', "#{prefix}"
    system "make cocoa-install"
  end
  def patches
    # this builds/installs dylibs besides the static libs 
    DATA
  end
end
__END__
diff --git a/lib/cocoa/Makefile.cocoa b/lib/cocoa/Makefile.cocoa
index 8785e13..5b45b41 100644
--- a/lib/cocoa/Makefile.cocoa
+++ b/lib/cocoa/Makefile.cocoa
@@ -41,10 +41,11 @@ HEADERS     = ../../include/GL/glfw.h ../internal.h platform.h
 ##########################################################################
 # Install GLFW header and static library
 ##########################################################################
-install: libglfw.a libglfw.pc
+install: libglfw.a  libglfw.dylib libglfw.pc
 	$(INSTALL) -d $(PREFIX)/lib
 	$(INSTALL) -c -m 644 libglfw.a $(PREFIX)/lib/libglfw.a
 	$(RANLIB) $(PREFIX)/lib/libglfw.a
+	$(INSTALL) -c -m 644 libglfw.dylib $(PREFIX)/lib/libglfw.dylib
 	$(INSTALL) -d $(PREFIX)/include/GL
 	$(INSTALL) -c -m 644 ../../include/GL/glfw.h $(PREFIX)/include/GL/glfw.h
 	$(INSTALL) -d $(PREFIX)/lib/pkgconfig
