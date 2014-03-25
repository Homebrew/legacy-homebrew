require 'formula'

class Pyside < Formula
  homepage 'http://www.pyside.org'
  url 'https://download.qt-project.org/official_releases/pyside/pyside-qt4.8+1.2.1.tar.bz2'
  mirror 'https://distfiles.macports.org/py-pyside/pyside-qt4.8+1.2.1.tar.bz2'
  sha1 'eec5bed37647dd8d3d1c7a610ad913312dd55910'

  head 'git://gitorious.org/pyside/pyside.git'

  depends_on :python => :recommended
  depends_on :python3 => :optional

  option "without-docs", "Skip building documentation"

  depends_on 'cmake' => :build
  depends_on 'qt'

  if build.with? 'python3'
    depends_on 'shiboken' => 'with-python3'
  else
    depends_on 'shiboken'
  end

  resource 'sphinx' do
    url 'https://pypi.python.org/packages/source/S/Sphinx/Sphinx-1.2.2.tar.gz'
    sha1 '9e424b03fe1f68e0326f3905738adcf27782f677'
  end

  patch :DATA # Fix moc_qpytextobject.cxx not found (https://codereview.qt-project.org/62479)

  def install
    if build.with? "docs"
      (buildpath/"sphinx").mkpath

      resource("sphinx").stage do
        system "python", "setup.py", "install",
                                     "--prefix=#{buildpath}/sphinx",
                                     "--record=installed.txt",
                                     "--single-version-externally-managed"
      end

      ENV.prepend_path "PATH", (buildpath/"sphinx/bin")
    else
      rm buildpath/"doc/CMakeLists.txt"
    end

    # Add out of tree build because one of its deps, shiboken, itself needs an
    # out of tree build in shiboken.rb.
    Language::Python.each_python(build) do |python, version|
      mkdir "macbuild#{version}" do
        qt = Formula["qt"].opt_prefix
        args = std_cmake_args + %W[
          -DSITE_PACKAGE=#{lib}/python#{version}/site-packages
          -DALTERNATIVE_QT_INCLUDE_DIR=#{qt}/include
          -DQT_SRC_DIR=#{qt}/src
        ]
        if version.to_s[0,1] == "2"
          args << "-DPYTHON_SUFFIX=-python#{version}"
        else
          major_version = version.to_s[0,1]
          minor_version = version.to_s[2,3]
          args << "-DPYTHON_SUFFIX=.cpython-#{major_version}#{minor_version}m"
          args << "-DUSE_PYTHON3=1"
        end
        args << ".."
        system "cmake", *args
        system "make"
        system "make", "install"
      end
    end
  end

  test do
    Language::Python.each_python(build) do |python, version|
      system python, "-c", "from PySide import QtCore"
    end
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
