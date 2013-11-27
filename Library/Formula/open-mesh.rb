require 'formula'

class OpenMesh < Formula
  homepage 'http://openmesh.org'
  url 'http://www.openmesh.org/fileadmin/openmesh-files/2.3/OpenMesh-2.3.tar.gz'
  sha1 '3cccb46afd6f8b0c60dfbdcd883806f77efd14c3'

  head 'http://openmesh.org/svnrepo/OpenMesh/trunk/', :using => :svn

  depends_on 'cmake' => :build
  depends_on 'qt'
  depends_on 'glew'

  def patches; DATA; end

  def install
    mkdir 'openmesh-build' do
      system "cmake -DCMAKE_INSTALL_PREFIX='#{prefix}' -DCMAKE_BUILD_TYPE=Release .."
      system "make install"
    end
  end

  test do
    system "#{bin}/mconvert", "-help"
  end
end

__END__
diff --git a/src/OpenMesh/Tools/Utils/getopt.h b/src/OpenMesh/Tools/Utils/getopt.h
index df0d7e0..af6bd55 100644
--- a/src/OpenMesh/Tools/Utils/getopt.h
+++ b/src/OpenMesh/Tools/Utils/getopt.h
@@ -21,6 +21,7 @@ OPENMESHDLLEXPORT extern int getopt(int nargc, char * const *nargv, const char *
 
 #  endif
 #else
+#include <unistd.h>
 #  include <getopt.h>
 #endif
 
