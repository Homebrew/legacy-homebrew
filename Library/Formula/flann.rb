require 'formula'

class Flann < Formula
  url 'http://people.cs.ubc.ca/~mariusm/uploads/FLANN/flann-1.6.11-src.zip'
  homepage 'http://www.cs.ubc.ca/~mariusm/index.php/FLANN/FLANN'
  md5 '5fd889b9f3777aa6e0d05b2546d25eb5'

  depends_on 'cmake'=> :build
  depends_on 'HDF5'
  depends_on 'GTest'

  def install
    system "cmake . #{std_cmake_parameters} -DBUILD_MATLAB_BINDINGS=OFF"
    system "make install"
  end
end
