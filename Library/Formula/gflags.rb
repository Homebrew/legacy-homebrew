class Gflags < Formula
  homepage "https://code.google.com/p/gflags/"
  url "https://github.com/schuhschuh/gflags/archive/v2.1.1.tar.gz"
  sha1 "59b37548b10daeaa87a3093a11d13c2442ac6849"
  head "https://github.com/schuhschuh/gflags.git"

  depends_on "cmake" => :build

  # Fix upstream shared-library-versioning http://git.io/IzGwnQ
  patch :DATA

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 17d38b4..ca2c1df 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -22,6 +22,8 @@ version_numbers (
     PACKAGE_VERSION_PATCH
 )

+set (PACKAGE_SOVERSION "${PACKAGE_VERSION_MAJOR}")
+
 # ----------------------------------------------------------------------------
 # options
 set (GFLAGS_NAMESPACE   "${PACKAGE_NAME}" CACHE STRING "C++ namespace identifier of gflags library.")
@@ -256,7 +258,9 @@ foreach (TYPE IN ITEMS STATIC SHARED)
         endif ()
         set_target_properties (
           gflags${opts}-${type} PROPERTIES COMPILE_DEFINITIONS "${defines}"
-                                           OUTPUT_NAME "gflags${opts}"
+                                           OUTPUT_NAME         "gflags${opts}"
+                                           VERSION             "${PACKAGE_VERSION}"
+                                           SOVERSION           "${PACKAGE_SOVERSION}"
         )
         if (HAVE_SHLWAPI_H)
           target_link_libraries (gflags${opts}-${type} shlwapi.lib)
@@ -280,9 +284,18 @@ if (OS_WINDOWS)
   set (CONFIG_INSTALL_DIR  CMake)
 else ()
   set (RUNTIME_INSTALL_DIR bin)
-  set (LIBRARY_INSTALL_DIR lib)
+  # The LIB_INSTALL_DIR and LIB_SUFFIX variables are used by the Fedora
+  # package maintainers. Also package maintainers of other distribution
+  # packages need to be able to specify the name of the library directory.
+  if (NOT LIB_INSTALL_DIR)
+    set (LIB_INSTALL_DIR "lib${LIB_SUFFIX}")
+  endif ()
+  set (LIBRARY_INSTALL_DIR "${LIB_INSTALL_DIR}"
+    CACHE PATH "Directory of installed libraries, e.g., \"lib64\""
+  )
+  mark_as_advanced (LIBRARY_INSTALL_DIR)
   set (INCLUDE_INSTALL_DIR include)
-  set (CONFIG_INSTALL_DIR  lib/cmake/${PACKAGE_NAME})
+  set (CONFIG_INSTALL_DIR  ${LIBRARY_INSTALL_DIR}/cmake/${PACKAGE_NAME})
 endif ()

 file (RELATIVE_PATH INSTALL_PREFIX_REL2CONFIG_DIR "${CMAKE_INSTALL_PREFIX}/${CONFIG_INSTALL_DIR}" "${CMAKE_INSTALL_PREFIX}")
diff --git a/cmake/CMakeCXXInformation.cmake b/cmake/CMakeCXXInformation.cmake
index 4d0a14a..9ddae4a 100644
--- a/cmake/CMakeCXXInformation.cmake
+++ b/cmake/CMakeCXXInformation.cmake
@@ -256,7 +256,7 @@ include(CMakeCommonLanguageInclude)
 # create a shared C++ library
 if(NOT CMAKE_CXX_CREATE_SHARED_LIBRARY)
   set(CMAKE_CXX_CREATE_SHARED_LIBRARY
-      "<CMAKE_CXX_COMPILER> <CMAKE_SHARED_LIBRARY_CXX_FLAGS> <LANGUAGE_COMPILE_FLAGS> <LINK_FLAGS> <CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS> <SONAME_FLAG><TARGET_SONAME> -o <TARGET> <OBJECTS> <LINK_LIBRARIES>")
+      "<CMAKE_CXX_COMPILER> <CMAKE_SHARED_LIBRARY_CXX_FLAGS> <LANGUAGE_COMPILE_FLAGS> <LINK_FLAGS> <CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS> <CMAKE_SHARED_LIBRARY_SONAME_CXX_FLAG><TARGET_SONAME> -o <TARGET> <OBJECTS> <LINK_LIBRARIES>")
 endif()

 # create a c++ shared module copy the shared library rule by default
diff --git a/doc/gflags.html b/doc/gflags.html
index 1a887b4..3a66713 100644
--- a/doc/gflags.html
+++ b/doc/gflags.html
@@ -269,7 +269,7 @@
 just a single function call:</p>

 <pre>
-   google::ParseCommandLineFlags(&argc, &argv, true);
+   gflags::ParseCommandLineFlags(&argc, &argv, true);
 </pre>

 <p>Usually, this code is at the beginning of <code>main()</code>.
@@ -529,8 +529,8 @@
 name (<code>argv[0]</code>).</p>

 <p>For more information about these routines, and other useful helper
-methods such as <code>google::SetUsageMessage()</code> and
-<code>google::SetVersionString</code>, see <code>gflags.h</code>.</p>
+methods such as <code>gflags::SetUsageMessage()</code> and
+<code>gflags::SetVersionString</code>, see <code>gflags.h</code>.</p>


 <h2> <A name="misc">Miscellaneous Notes</code> </h2>
