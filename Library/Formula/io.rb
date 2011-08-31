require 'formula'

class Io < Formula
  head 'https://github.com/stevedekorte/io.git'
  homepage 'http://iolanguage.com/'

  depends_on 'cmake' => :build
  depends_on 'libsgml'
  depends_on 'ossp-uuid'
  depends_on 'libevent'

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
diff --git a/addons/Image/CMakeLists.txt b/addons/Image/CMakeLists.txt
index a65693d..2166f1b 100644
--- a/addons/Image/CMakeLists.txt
+++ b/addons/Image/CMakeLists.txt
@@ -22,7 +22,7 @@ if(PNG_FOUND AND TIFF_FOUND AND JPEG_FOUND)
 	add_definitions(-DBUILDING_IMAGE_ADDON)
 
 	# Additional include directories
-	include_directories(${PNG_INCLUDE_DIR} ${TIFF_INCLUDE_DIR} ${JPEG_INCLUDE_DIR})
+	include_directories("/usr/X11/include" ${PNG_INCLUDE_DIR} ${TIFF_INCLUDE_DIR} ${JPEG_INCLUDE_DIR})
 
 	# Generate the IoImageInit.c file.
 	# Argument SHOULD ALWAYS be the exact name of the addon, case is
