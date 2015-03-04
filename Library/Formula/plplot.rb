require 'formula'

class Plplot < Formula
  homepage 'http://plplot.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/plplot/plplot/5.10.0%20Source/plplot-5.10.0.tar.gz'
  sha1 'ea962cb0138c9b4cbf97ecab1fac1919ea0f939f'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'pango'
  depends_on :x11 => :optional

  option 'with-java'

  # patch taken from upstream http://sourceforge.net/p/plplot/plplot/ci/772223c638ecf5dc740c9f3dd7a6883c6d2c83d2
  # fixes https://github.com/Homebrew/homebrew/issues/36569
  patch :DATA

  def install
    args = std_cmake_args
    args << '-DPLD_wxwidgets=OFF' << '-DENABLE_wxwidgets=OFF'
    args << '-DENABLE_java=OFF' if build.without? 'java'
    args << '-DPLD_xcairo=OFF' if build.without? 'x11'
    args << '-DENABLE_ada=OFF'
    mkdir "plplot-build" do
      system "cmake", "..", *args
      system "make"
      system "make install"
    end
  end
end
__END__
--- a/cmake/modules/pkg-config.cmake
+++ b/cmake/modules/pkg-config.cmake
@@ -1,6 +1,6 @@
 # cmake/modules/pkg-config.cmake
 #
-# Copyright (C) 2006  Alan W. Irwin
+# Copyright (C) 2006-2015 Alan W. Irwin
 #
 # This file is part of PLplot.
 #
@@ -94,7 +94,12 @@
     set(_xprefix ${_prefix})
   endif(FORCE_EXTERNAL_STATIC)
   
-  _pkg_check_modules_internal(0 0 ${_prefix} "${_package}")
+  if(CMAKE_VERSION VERSION_LESS "3.1")
+    _pkg_check_modules_internal(0 0 ${_prefix} "${_package}")
+  else(CMAKE_VERSION VERSION_LESS "3.1")
+    _pkg_check_modules_internal(0 0 0 0 ${_prefix} "${_package}")
+  endif(CMAKE_VERSION VERSION_LESS "3.1")
+    
   if(${_prefix}_FOUND)
     cmake_link_flags(${_link_FLAGS} "${${_xprefix}_LDFLAGS}")
     # If libraries cannot be not found, then that is equivalent to whole
