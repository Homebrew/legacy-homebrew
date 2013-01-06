require 'formula'

class Insighttoolkit < Formula
  homepage 'http://www.itk.org'
  url 'http://sourceforge.net/projects/itk/files/itk/4.3/InsightToolkit-4.3.1.tar.gz'
  sha1 '85375a316dd39f7f70dee5a2bd022f768db28eeb'

  head 'git://itk.org/ITK.git'

  option 'examples', 'Compile and install various examples'
  option 'python',   'Enable python wrapping of ITK classes'

  depends_on 'cmake' => :build

  def install
    args = std_cmake_args + %W[
      -DBUILD_TESTING=OFF
      -DBUILD_SHARED_LIBS=ON
    ]
    args << ".."
    args << '-DBUILD_EXAMPLES=' + ((build.include? 'examples') ? 'ON' : 'OFF')


    if build.include? 'python'
      args = args + %W[
        -DITK_WRAP_PYTHON=ON
        -DModule_ITKVtkGlue=ON
        -DCMAKE_C_FLAGS='-ansi'
      ]

      # These environment variables are necessary for gccxml to work properly
      # llvm-g++ will usually be in this location, do we have to check?
      ENV['GCCXML_COMPILER']=#{ENV.cxx}
      ENV['GCCXML_CXXFLAGS']='-pipe -O2 -arch x86_64 '

      # ansi necessary to fix dependencies of WRAP_PYTHON
      # Module_ITKVtkGlue allows you to link ITK and VTK, see eg http://paulnovo.us/wrapitktutorial

      # Cmake picks up the system's python dylib, even if we have a brewed one.
      python_prefix = `python-config --prefix`.strip
      args << "-DPYTHON_LIBRARY='#{python_prefix}/Python'"

      # Other python options (cfr vtk formula) do not seem necessary
    end

    mkdir 'itk-build' do
      system "cmake", *args
      system "make install"
    end
  end
end
