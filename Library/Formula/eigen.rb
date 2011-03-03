require 'formula'

class Eigen <Formula
  url 'http://bitbucket.org/eigen/eigen/get/2.0.15.tar.bz2'
  homepage 'http://eigen.tuxfamily.org/'
  md5 'a96fe69d652d7b3b1d990c99bbc518fb'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
