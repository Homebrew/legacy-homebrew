require 'formula'

class Flann < Formula
  url 'http://people.cs.ubc.ca/~mariusm/uploads/FLANN/flann-1.6.11-src.zip'
  homepage 'http://www.cs.ubc.ca/~mariusm/index.php/FLANN/FLANN'
  md5 '5fd889b9f3777aa6e0d05b2546d25eb5'

  depends_on 'cmake'
  depends_on 'octave'
  depends_on 'gtest'
  depends_on 'hdf5'
  depends_on 'numpy' => :python

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

  def test
    # this will fail we won't accept that, make it test the program works!
    system "/usr/bin/false"
  end
end
