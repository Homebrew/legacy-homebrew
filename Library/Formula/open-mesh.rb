require 'formula'

class OpenMesh < Formula
  homepage 'http://openmesh.org'
  url 'http://www.openmesh.org/fileadmin/openmesh-files/2.4/OpenMesh-2.4.tar.gz'
  sha1 '5fd3f27e8c5803caf003c752de2dffc88ae4f874'

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
 
