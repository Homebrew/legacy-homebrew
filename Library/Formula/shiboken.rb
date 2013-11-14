require 'formula'

class Shiboken < Formula
  homepage 'http://www.pyside.org/docs/shiboken'
  url 'https://download.qt-project.org/official_releases/pyside/shiboken-1.2.1.tar.bz2'
  mirror 'https://distfiles.macports.org/py-shiboken/shiboken-1.2.1.tar.bz2'
  sha1 'f310ac163f3407109051ccebfd192bc9620e9124'

  head 'git://gitorious.org/pyside/shiboken.git'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'google-sparsehash' => :build
  depends_on :python => :recommended
  depends_on :python3 => :optional
  depends_on 'qt'

  def install
    # This block will be run for each python (2.x and 3.x if requested)!
    python do
      # As of 1.1.1 the install fails unless you do an out of tree build and put
      # the source dir last in the args.
      mkdir "macbuild#{python.if3then3}" do
        args = std_cmake_args
        # Building the tests also runs them.
        args << "-DBUILD_TESTS=ON"
        # For Xcode-only systems, the headers of system's python are inside of Xcode:
        args << "-DPYTHON#{python.if3then3}_INCLUDE_DIR='#{python.incdir}'"
        # Cmake picks up the system's python dylib, even if we have a brewed one:
        args << "-DPYTHON#{python.if3then3}_LIBRARY='#{python.libdir}/lib#{python.xy}.dylib'"
        args << "-DUSE_PYTHON3=ON" if python3
        args << '..'
        system 'cmake', *args
        system "make install"
        # To support 2.x and 3.x in parallel, we have to rename shiboken.pc at first
        mv lib/'pkgconfig/shiboken.pc', lib/"pkgconfig/shiboken-py#{python.version.major}.pc"
      end
    end
    # Rename shiboken-py2.pc back to the default shiboken.pc
    mv lib/'pkgconfig/shiboken-py2.pc', lib/'pkgconfig/shiboken.pc' if python2
  end

  def caveats
    if python3
      <<-EOS.undent
        If you build software that uses the pkgconfig file, and you want
        shiboken with Python 3.x support: Please, instead of 'shiboken.pc', use:
          #{HOMEBREW_PREFIX}/lib/pkgconfig/shiboken-py3.pc
      EOS
    end
  end

  test do
    python do
      system python, "-c", "import shiboken"
    end
  end

  def patches
    # Fixes build failure with clang and libc++
    # see https://github.com/PySide/Shiboken/pull/71
    DATA
  end
end

__END__
diff --git a/libshiboken/CMakeLists.txt b/libshiboken/CMakeLists.txt
index c8575e7..c17ef4c 100644
--- a/libshiboken/CMakeLists.txt
+++ b/libshiboken/CMakeLists.txt
@@ -11,8 +11,10 @@ configure_file("${CMAKE_CURRENT_SOURCE_DIR}/sbkversion.h.in"
                "${CMAKE_CURRENT_BINARY_DIR}/sbkversion.h" @ONLY)
 
 #Find installed sparsehash
-find_path(SPARSEHASH_INCLUDE_PATH sparseconfig.h PATH_SUFFIXES "/google/sparsehash")
-if(SPARSEHASH_INCLUDE_PATH)
+find_package(PkgConfig)
+pkg_check_modules(SPARSEHASH libsparsehash)
+if(SPARSEHASH_FOUND)
+    set(SPARSEHASH_INCLUDE_PATH ${SPARSEHASH_INCLUDE_DIRS})
     message(STATUS "Using system hash found in: ${SPARSEHASH_INCLUDE_PATH}")
 else()
     set(SPARSEHASH_INCLUDE_PATH ${CMAKE_SOURCE_DIR}/ext/sparsehash)
diff --git a/tests/libsample/simplefile.cpp b/tests/libsample/simplefile.cpp
index deac166..573a9d6 100644
--- a/tests/libsample/simplefile.cpp
+++ b/tests/libsample/simplefile.cpp
@@ -90,13 +90,13 @@ bool
 SimpleFile::exists() const
 {
     std::ifstream ifile(p->m_filename);
-    return ifile;
+    return bool(ifile);
 }
 
 bool
 SimpleFile::exists(const char* filename)
 {
     std::ifstream ifile(filename);
-    return ifile;
+    return bool(ifile);
 }
 
