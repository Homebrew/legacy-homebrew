require 'formula'

class Orfeo < Formula
  homepage 'http://www.orfeo-toolbox.org/otb/'
  url 'http://downloads.sourceforge.net/project/orfeo-toolbox/OTB/OTB-3.20/OTB-3.20.0.tgz'
  sha1 '2af5b4eb857d0f1ecb1fd1107c6879f9d79dd0fc'

  depends_on 'cmake' => :build
  depends_on :python => :optional
  depends_on 'fltk'
  depends_on 'gdal'
  depends_on 'qt'

  option 'examples', 'Compile and install various examples'
  option 'java', 'Enable Java support'
  option 'patented', 'Enable patented algorithms'

  def install
    args = std_cmake_args + %W[
      -DBUILD_APPLICATIONS=ON
      -DOTB_USE_EXTERNAL_FLTK=ON
      -DBUILD_TESTING=OFF
      -DBUILD_SHARED_LIBS=ON
      -DOTB_WRAP_QT=ON
    ]

    args << '-DBUILD_EXAMPLES=' + ((build.include? 'examples') ? 'ON' : 'OFF')
    args << '-DOTB_WRAP_JAVA=' + ((build.include? 'java') ? 'ON' : 'OFF')
    args << '-DOTB_USE_PATENTED=' + ((build.include? 'patented') ? 'ON' : 'OFF')
    if python do
      args << '-DOTB_WRAP_PYTHON=ON'
      # For Xcode-only systems, the headers of system's python are inside of Xcode:
      args << "-DPYTHON_INCLUDE_DIR='#{python.incdir}'"
      # Cmake picks up the system's python dylib, even if we have a brewed one:
      args << "-DPYTHON_LIBRARY='#{python.libdir}/lib#{python.xy}.dylib'"
    end; else
      args << '-DOTB_WRAP_PYTHON=OFF'
    end

    mkdir 'build' do
      system 'cmake', '..', *args
      system 'make'
      system 'make install'
    end
  end
end
