require 'formula'

class Eigen2 < Formula
  url 'http://bitbucket.org/eigen/eigen/get/2.0.17.tar.gz'
  homepage 'http://eigen.tuxfamily.org/'
 md5 'd13ad41c002b3d55cd241f6dbd83cc6c'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
