require 'formula'

class Freeglut < Formula
  homepage 'http://freeglut.sourceforge.net/'
  url 'http://sourceforge.net/projects/freeglut/files/freeglut/2.8.1/freeglut-2.8.1.tar.gz'
  sha1 '7330b622481e2226c0c9f6d2e72febe96b03f9c4'

  depends_on :x11

  def patches
    DATA if MacOS.version >= :lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make all"
    system "make install"
  end
end

__END__

diff -ur org/freeglut-2.8.1/include/GL/freeglut_std.h freeglut-2.8.1/include/GL/freeglut_std.h
--- org/freeglut-2.8.1/include/GL/freeglut_std.h
+++ freeglut-2.8.1/include/GL/freeglut_std.h
@@ -122,7 +122,7 @@
  * Always include OpenGL and GLU headers
  */
 #if __APPLE__
-#   include <OpenGL/gl.h>
+#   include <OpenGL/gl3.h>
 #   include <OpenGL/glu.h>
 #else
 #   include <GL/gl.h>
