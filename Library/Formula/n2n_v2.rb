require 'formula'

class N2nV2 < Formula
  homepage 'http://www.ntop.org/products/n2n'
  url 'https://github.com/meyerd/n2n.git', :revision => '76dd9eb'
  version '2.1'
  head 'https://github.com/meyerd/n2n.git', :branch => 'new_protocol'

  depends_on 'cmake' => :build
  depends_on 'libgcrypt'
  depends_on 'gnutls'

  # Fix man installation
  def patches; DATA end

  def install
    cd "n2n_v2" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end
end
__END__
--- a/n2n_v2/CMakeLists.txt
+++ b/n2n_v2/CMakeLists.txt
@@ -132,9 +132,9 @@
                             PROPERTIES GENERATED 1)
 
 install(FILES ${PROJECT_BINARY_DIR}/doc/edge.8.gz
-        DESTINATION /usr/share/man8)
+        DESTINATION share/man/man8)
 install(FILES ${PROJECT_BINARY_DIR}/doc/supernode.1.gz
-        DESTINATION /usr/share/man1)
+        DESTINATION share/man/man1)
 install(FILES ${PROJECT_BINARY_DIR}/doc/n2n_v2.7.gz
-        DESTINATION /usr/share/man7)
+        DESTINATION share/man/man7)
 endif(DEFINED UNIX)
