require 'formula'

class X265 < Formula
  homepage 'http://x265.org'
  url 'https://bitbucket.org/multicoreware/x265/get/0.4.1.tar.bz2'
  sha1 'a3441aa6f1dc0940b89a53bec8031492bca1fa86'

  head 'https://bitbucket.org/multicoreware/x265', :using => :hg

  depends_on 'yasm' => :build
  depends_on 'cmake' => :build
  depends_on :macos => :lion

  fails_with :gcc do
    build 5666
    cause '-mstackrealign not supported in the 64bit mode'
  end

  fails_with :llvm do
    build 2335
    cause '-mstackrealign not supported in the 64bit mode'
  end

  def patches
      # superenv removes -march=core-avx2
      DATA
  end if build.head?

  def install

    args = std_cmake_args
    args.delete '-DCMAKE_BUILD_TYPE=None'
    args << '-DCMAKE_BUILD_TYPE=Release'

    system "cmake", "source",  *args
    system "make"
    bin.install 'x265'
  end
end

__END__
diff --git a/source/common/CMakeLists.txt b/source/common/CMakeLists.txt
index 62bacd2..9b15eec 100644
--- a/source/common/CMakeLists.txt
+++ b/source/common/CMakeLists.txt
@@ -134 +134 @@ if(ENABLE_PRIMITIVES_VEC)
-                PROPERTIES COMPILE_FLAGS "-march=core-avx2")
+                PROPERTIES COMPILE_FLAGS "-mavx2")
