require 'formula'

class Glfw3 < Formula
  homepage 'http://www.glfw.org/'
  url 'http://downloads.sourceforge.net/project/glfw/glfw/3.0.2/glfw-3.0.2.tar.bz2'
  sha1 'eb7f5b74e5469eaa09101f00891ba5e7405faeb9'

  depends_on 'cmake' => :build

  option :universal
  option :static, 'Build static library only (defaults to building dylib only)'
  option :'build-examples', 'Build examples'
  option :'build-tests', 'Build test programs'

  def patches
    # make library name consistent
    DATA
  end

  def install
    ENV.universal_binary if build.universal?

    args = std_cmake_args + %W[
      -DGLFW_USE_CHDIR=TRUE
      -DGLFW_USE_MENUBAR=TRUE
    ]
    args << '-DGLFW_BUILD_UNIVERSAL=TRUE' if build.universal?
    args << '-DBUILD_SHARED_LIBS=TRUE' unless build.include? 'static'
    args << '-DGLFW_BUILD_EXAMPLES=TRUE' if build.include? 'build-examples'
    args << '-DGLFW_BUILD_TESTS=TRUE' if build.include? 'build-tests'
    args << '.'

    system 'cmake', *args
    system 'make', 'install'
  end
end

__END__
diff -u a/CMakeLists.txt b/CMakeLists.txt
index
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -357,12 +357,7 @@
 #--------------------------------------------------------------------
 # Choose library output name
 #--------------------------------------------------------------------
-if (BUILD_SHARED_LIBS AND UNIX)
-    # On Unix-like systems, shared libraries can use the soname system.
-    set(GLFW_LIB_NAME glfw)
-else()
-    set(GLFW_LIB_NAME glfw3)
-endif()
+set(GLFW_LIB_NAME glfw3)
 
 #--------------------------------------------------------------------
 # Add subdirectories
