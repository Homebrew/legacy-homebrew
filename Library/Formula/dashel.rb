require "formula"

class Dashel < Formula
  homepage "https://github.com/aseba-community/dashel"
  url "https://github.com/aseba-community/dashel/archive/1.0.8.tar.gz"
  sha1 "ea93321250c4bb32c48e7fecf72554a068d64192"

  depends_on "cmake" => :build

  # fix broken installation path for dashelConfig.cmake
  patch :DATA

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    (share+"test").install "portlist"
  end

  test do
    system "#{share}/test/portlist"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 4121c0a..a1fda9b 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -73,7 +73,7 @@ if (WIN32 AND NOT CYGWIN)
 	set(INSTALL_CMAKE_DIR CMake)
 else()
 	if (APPLE)
-		set(INSTALL_CMAKE_DIR dashel.framework/Resources/CMake/)
+		set(INSTALL_CMAKE_DIR Frameworks/dashel.framework/Resources/CMake/)
 	else()
 		set(INSTALL_CMAKE_DIR share/dashel/CMake)
 	endif()

