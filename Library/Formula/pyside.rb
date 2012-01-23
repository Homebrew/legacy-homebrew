require 'formula'

def which_python
  "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
end

def site_package_dir
  "lib/#{which_python}/site-packages"
end

class Pyside < Formula
  homepage 'http://www.pyside.org'
  url 'http://www.pyside.org/files/pyside-qt4.7+1.0.8.tar.bz2'
  md5 '131cc4d5c56b3b20bc99362f68f3f29d'

  depends_on 'cmake' => :build

  depends_on 'shiboken'
  depends_on 'generatorrunner'
  depends_on 'apiextractor'
  depends_on 'qt'

  def patches
    # Fix an infinite loop that was added to the CMake config file in
    # PySide 1.0.8
    DATA
  end

  def install
    # The build will be unable to find Qt headers buried inside frameworks
    # unless the folder containing those frameworks is added to the compiler
    # search path.
    qt = Formula.factory 'qt'
    ENV.append_to_cflags "-F#{qt.prefix}/Frameworks"

    # Also need `ALTERNATIVE_QT_INCLUDE_DIR` to prevent "missing file" errors.
    system "cmake . #{std_cmake_parameters} -DALTERNATIVE_QT_INCLUDE_DIR=#{qt.prefix}/Frameworks -DSITE_PACKAGE=#{site_package_dir} -DBUILD_TESTS=NO"
    system 'make install'
  end

  def caveats
    <<-EOS
PySide Python modules have been linked to:
    #{HOMEBREW_PREFIX}/#{site_package_dir}

Make sure this folder is on your PYTHONPATH. For PySide development tools,
install the `pyside-tools` formula.
    EOS
  end
end

__END__
Ensure PySideConfig.cmake gets generated with a default value for
SHIBOKEN_PYTHON_SUFFIX, otherwise an infinite loop will occur.

Submitted upstream:

  http://bugs.pyside.org/show_bug.cgi?id=1052

diff --git a/libpyside/PySideConfig.cmake.in b/libpyside/PySideConfig.cmake.in
index b83c48b..ab7b389 100644
--- a/libpyside/PySideConfig.cmake.in
+++ b/libpyside/PySideConfig.cmake.in
@@ -1,5 +1,5 @@
-if (NOT PYTHON_BASENAME)
-    message(STATUS "Using default python: @PYTHON_BASENAME@")
-    SET(PYTHON_BASENAME @PYTHON_BASENAME@)
+if (NOT SHIBOKEN_PYTHON_SUFFIX)
+  message(STATUS "Using default python: @SHIBOKEN_PYTHON_SUFFIX@")
+  SET(SHIBOKEN_PYTHON_SUFFIX @SHIBOKEN_PYTHON_SUFFIX@)
 endif()
 include(@LIB_INSTALL_DIR@/cmake/PySide-@BINDING_API_VERSION@/PySideConfig${SHIBOKEN_PYTHON_SUFFIX}.cmake)
