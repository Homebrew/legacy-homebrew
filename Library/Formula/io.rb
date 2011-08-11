require 'formula'

class Io < Formula
  head 'https://github.com/stevedekorte/io.git'
  homepage 'http://iolanguage.com/'

  depends_on 'cmake' => :build
  depends_on 'libsgml'
  depends_on 'ossp-uuid'

  # Either CMake doesn't detect OS X's png include path correctly,
  # or there's an issue with io's build system; force the path in
  # so we can build.
  def patches
    DATA
  end

  def install
    ENV.j1
    mkdir 'io-build'

    Dir.chdir 'io-build' do
      system "cmake .. #{std_cmake_parameters}"
      system "make install"
    end

    rm_f Dir['docs/*.pdf']
    doc.install Dir['docs/*']

    prefix.install 'license/bsd_license.txt' => 'LICENSE'
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index a4cd440..e2d05eb 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -140,7 +140,7 @@ IF(WIN32 AND NOT CYGWIN)
 ELSE(WIN32 AND NOT CYGWIN)
 	execute_process(COMMAND git rev-parse --short HEAD OUTPUT_VARIABLE IO_GIT_REV)
 ENDIF(WIN32 AND NOT CYGWIN)
-string(REGEX REPLACE "(.......)." "\\1" IO_GIT_REV ${IO_GIT_REV})
+string(REGEX REPLACE "(.......)." "\\1" IO_GIT_REV ${IO_GIT_REV} "" "")
 
 SET(CPACK_PACKAGE_NAME ${PROJECT_NAME})
 SET(CPACK_PACKAGE_VENDOR "iolanguage.com")
diff --git a/addons/Image/CMakeLists.txt b/addons/Image/CMakeLists.txt
index 295045f..9b038eb 100644
--- a/addons/Image/CMakeLists.txt
+++ b/addons/Image/CMakeLists.txt
@@ -22,7 +22,7 @@ if(PNG_FOUND AND TIFF_FOUND AND JPEG_FOUND)
 	add_definitions(-DBUILDING_IMAGE_ADDON)
 
 	# Additional include directories
-	include_directories(${PNG_INCLUDE_DIR} ${TIFF_INCLUDE_DIR} ${JPEG_INCLUDE_DIR})
+  include_directories("/usr/X11/include" ${PNG_INCLUDE_DIR} ${TIFF_INCLUDE_DIR} ${JPEG_INCLUDE_DIR})
 
 	# Generate the IoImageInit.c file.
 	# Argument SHOULD ALWAYS be the exact name of the addon, case is
