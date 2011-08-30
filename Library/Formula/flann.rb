require 'formula'

class Flann < Formula
  url 'http://people.cs.ubc.ca/~mariusm/uploads/FLANN/flann-1.6.11-src.zip'
  homepage 'http://www.cs.ubc.ca/~mariusm/index.php/FLANN/FLANN'
  md5 '5fd889b9f3777aa6e0d05b2546d25eb5'

  def options
    [
      ['--enable-python', 'Enable python bindings.'],
      ['--enable-matlab', 'Enable matlab/octave bindings.'],
      ['--with-examples', 'Build and install example binaries']
    ]
  end

  depends_on 'cmake' => :build
  depends_on 'gtest' => :build
  depends_on 'hdf5'

  depends_on 'octave' if ARGV.include? '--enable-matlab'
  depends_on 'numpy' => :python if ARGV.include? '--enable-python'

  def install
    args = std_cmake_parameters.split
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

    Dir.mkdir 'build'
    Dir.chdir 'build' do
      system 'cmake', '..', *args
      system 'make install'
    end
  end
end
