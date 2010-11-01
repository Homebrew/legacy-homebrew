require 'formula'

class Eigen <Formula
  url 'http://bitbucket.org/eigen/eigen/get/2.0.12.tar.bz2'
  homepage 'http://eigen.tuxfamily.org/'
  md5 'd0195ac20bcd91602db8ca967a21e9ec'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
