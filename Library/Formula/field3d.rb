require 'formula'

class Field3d < Formula
  homepage 'https://sites.google.com/site/field3d/'
  url 'https://github.com/imageworks/Field3D/tarball/v1.3.2'
  sha1 '6f4de442869587f7fa5ce6f5f8bd0630b6ae7192'

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'ilmbase'
  depends_on 'hdf5'

  def patches
    # add boost system to required boost libs
    # already reported upstream, see https://github.com/imageworks/Field3D/pull/51
    # Remove at > 1.3.2
    DATA
  end

  def install
    mkdir 'brewbuild' do
      args = std_cmake_args + %w[
        -DDOXYGEN_EXECUTABLE=NOTFOUND
        ..]
      system "cmake",  *args
      system "make install"
    end
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index f382937..82d2487 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -39,7 +39,7 @@ set( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR}/cmake )

 FIND_PACKAGE (Doxygen)
 FIND_PACKAGE (HDF5)
-FIND_PACKAGE (Boost COMPONENTS thread program_options)
+FIND_PACKAGE (Boost COMPONENTS system thread program_options)
 FIND_PACKAGE (ILMBase)

 OPTION (INSTALL_DOCS "Automatically install documentation." ON)
