require 'formula'

class Freeglut < Formula
  homepage 'http://freeglut.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/freeglut/freeglut/2.8.1/freeglut-2.8.1.tar.gz'
  sha1 '7330b622481e2226c0c9f6d2e72febe96b03f9c4'

  # Examples won't build on Snow Leopard as one of them requires
  # a header the system provided X11 doesn't have.
  option 'with-examples', "Build the examples."
  option :universal

  depends_on :x11

  patch :DATA if MacOS.version >= :lion

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    if build.without?('examples') || MacOS.version < :lion
      inreplace 'Makefile' do |s|
        s.change_make_var! 'SUBDIRS', 'src include doc'
      end
    end

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
