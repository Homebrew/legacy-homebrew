require 'formula'

class Flann < Formula
  url 'http://people.cs.ubc.ca/~mariusm/uploads/FLANN/flann-1.6.11-src.zip'
  homepage 'http://www.cs.ubc.ca/~mariusm/index.php/FLANN/FLANN'
  md5 '5fd889b9f3777aa6e0d05b2546d25eb5'

  depends_on 'cmake' => :build
  depends_on 'gtest' => :build
  depends_on 'hdf5'

  def options
    [
      ['--python', "Enable python bindings."],
      ['--matlab', "Enable matlab/octave bindings."]
  ]
  end

  def install
    args = std_cmake_parameters.split
    if ARGV.include? '--matlab'
      args << "-DBUILD_MATLAB_BINDINGS:BOOL=ON"
    else
      args << "-DBUILD_MATLAB_BINDINGS:BOOL=OFF"
    end
    
    if ARGV.include? '--python'
      args << "-DBUILD_PYTHON_BINDINGS:BOOL=ON"
    else
      args << "-DBUILD_PYTHON_BINDINGS:BOOL=OFF"
    end
    
    Dir.mkdir 'build'
    args << ".."
    Dir.chdir 'build' do
      system "cmake", *args
      system "make install"
    end
  end
end
