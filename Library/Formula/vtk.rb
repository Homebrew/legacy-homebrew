require 'formula'

class Vtk < Formula
  url 'http://www.vtk.org/files/release/5.6/vtk-5.6.1.tar.gz'
  homepage 'http://www.vtk.org'
  md5 'b80a76435207c5d0f74dfcab15b75181'

  depends_on 'cmake' => :build
  depends_on 'qt' if ARGV.include? '--qt'

  def options
  [
    ['--python', "Enable python wrapping."],
    ['--qt', "Enable Qt extension."],
    ['--tcl', "Enable Tcl wrapping."],
  ]
  end

  def install
    args = [ "#{std_cmake_parameters}",
             "-DVTK_REQUIRED_OBJCXX_FLAGS:STRING=''",
             "-DVTK_USE_CARBON:BOOL=OFF",
             "-DVTK_USE_COCOA:BOOL=ON",
             "-DBUILD_TESTING:BOOL=OFF",
             "-DBUILD_EXAMPLES:BOOL=OFF",
             "-DBUILD_SHARED_LIBS:BOOL=ON",
             "-DVTK_USE_RPATH:BOOL=ON" ]

    if ARGV.include? '--python'
      python_version = `python -V 2>&1`.match('Python (\d+\.\d+)').captures.at(0)
      ENV.append 'PYTHONPATH', ':', '#{lib}/python#{python_version}/site-packages'
      args << "-DVTK_WRAP_PYTHON:BOOL=ON"
    end

    if ARGV.include? '--qt'
      args << "-DVTK_USE_GUISUPPORT:BOOL=ON"
      args << "-DVTK_USE_QT:BOOL=ON"
      args << "-DVTK_USE_QVTK:BOOL=ON"
      args << "-DDESIRED_QT_VERSION=4"
      args << "-DVTK_USE_QVTK_OPENGL:BOOL=ON"
    end

    if ARGV.include? '--tcl'
      args << "-DVTK_WRAP_TCL:BOOL=ON"
    end

    args << "-DCMAKE_INSTALL_RPATH:STRING='${CMAKE_INSTALL_PREFIX}/lib/vtk-5.6'"
    args << "-DCMAKE_INSTALL_NAME_DIR:STRING='${CMAKE_INSTALL_PREFIX}/lib/vtk-5.6'"

    system "mkdir build"
    args << ".."
    Dir.chdir 'build' do
      system "cmake", *args
      system "make"
      system "make install"
    end
  end
end
