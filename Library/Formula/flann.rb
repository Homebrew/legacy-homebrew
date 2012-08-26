require 'formula'

class Flann < Formula
  homepage 'http://www.cs.ubc.ca/~mariusm/index.php/FLANN/FLANN'
  url 'http://people.cs.ubc.ca/~mariusm/uploads/FLANN/flann-1.7.1-src.zip'
  md5 'd780795f523eabda7c7ea09c6f5cf235'

  def options
    [
      ['--enable-python', 'Enable python bindings.'],
      ['--enable-matlab', 'Enable matlab/octave bindings.'],
      ['--with-examples', 'Build and install example binaries']
    ]
  end

  depends_on 'cmake' => :build
  depends_on 'hdf5'

  depends_on 'octave' if ARGV.include? '--enable-matlab'
  depends_on 'numpy' => :python if ARGV.include? '--enable-python'

  def install
    args = std_cmake_args
    if ARGV.include? '--enable-matlab'
      args << '-DBUILD_MATLAB_BINDINGS:BOOL=ON'
    else
      args << '-DBUILD_MATLAB_BINDINGS:BOOL=OFF'
    end

    if ARGV.include? '--enable-python'
      args << '-DBUILD_PYTHON_BINDINGS:BOOL=ON'
    else
      args << '-DBUILD_PYTHON_BINDINGS:BOOL=OFF'
    end

    inreplace 'CMakeLists.txt', 'add_subdirectory( examples )', '' unless ARGV.include? '--with-examples'

    mkdir 'build'
    cd 'build' do
      system 'cmake', '..', *args
      system 'make install'
    end
  end
end
