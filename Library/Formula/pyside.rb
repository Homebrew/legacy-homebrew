require 'formula'

class Pyside < Formula
  homepage 'http://www.pyside.org'
  url 'https://download.qt-project.org/official_releases/pyside/pyside-qt4.8+1.2.0.tar.bz2'
  mirror 'https://distfiles.macports.org/py-pyside/pyside-qt4.8+1.2.0.tar.bz2'
  sha1 'b7bbb068f775cea6c42a86dc2796ed7dd4f36555'

  head 'git://gitorious.org/pyside/pyside.git'

  depends_on 'cmake' => :build
  depends_on :python => :recommended
  depends_on :python3 => :optional

  if build.with? 'python3'
    depends_on 'shiboken' => 'with-python3'
  else
    depends_on 'shiboken'
  end

  depends_on 'qt'

  def patches
    DATA  # Fix moc_qpytextobject.cxx not found (https://codereview.qt-project.org/62479)
  end

  def install
    python do
      # Add out of tree build because one of its deps, shiboken, itself needs an
      # out of tree build in shiboken.rb.
      mkdir "macbuild#{python.if3then3}" do
        args = std_cmake_args + %W[
          -DSITE_PACKAGE=#{python.site_packages}
          -DALTERNATIVE_QT_INCLUDE_DIR=#{Formula.factory('qt').opt_prefix}/include
          -DQT_SRC_DIR=#{Formula.factory('qt').opt_prefix}/src
          ..
        ]
        # The next two lines are because shiboken needs them
        args << "-DPYTHON_SUFFIX='-python2.7'" if python2
        args << "-DPYTHON_SUFFIX='.cpython-33m'" if python3
        system 'cmake', *args
        system 'make'
        system 'make', 'install'
        system 'make', 'clean'
        # Todo: How to deal with pyside.pc file? It doesn't support 2.x and 3.x!
      end
    end
  end

  test do
    python do
      system python, '-c', "from PySide import QtCore"
    end
  end

  def caveats
    python.standard_caveats if python
  end
end

__END__
diff --git a/PySide/QtGui/CMakeLists.txt b/PySide/QtGui/CMakeLists.txt
index 7625634..6e14706 100644
--- a/PySide/QtGui/CMakeLists.txt
+++ b/PySide/QtGui/CMakeLists.txt
@@ -403,7 +403,6 @@ ${CMAKE_CURRENT_BINARY_DIR}/PySide/QtGui/qwizard_wrapper.cpp
 ${CMAKE_CURRENT_BINARY_DIR}/PySide/QtGui/qworkspace_wrapper.cpp

 ${SPECIFIC_OS_FILES}
-${QPYTEXTOBJECT_MOC}
 ${QtGui_46_SRC}
 ${QtGui_47_SRC}
 ${QtGui_OPTIONAL_SRC}
@@ -434,7 +433,7 @@ create_pyside_module(QtGui
                      QtGui_deps
                      QtGui_typesystem_path
                      QtGui_SRC
-                     ""
+                     QPYTEXTOBJECT_MOC
                      ${CMAKE_CURRENT_BINARY_DIR}/typesystem_gui.xml)

 install(FILES ${pyside_SOURCE_DIR}/qpytextobject.h DESTINATION include/PySide/QtGui/)
