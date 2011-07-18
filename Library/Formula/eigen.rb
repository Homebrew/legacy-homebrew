require 'formula'

class Eigen < Formula
  url 'http://bitbucket.org/eigen/eigen/get/3.0.1.tar.bz2'
  homepage 'http://eigen.tuxfamily.org/'
  md5 '542f0b304b42aade9b8bdd70e824328b'

  depends_on 'cmake' => :build

  def install
    mkdir 'eigen-build'
    Dir.chdir 'eigen-build' do
      system "cmake ..  #{std_cmake_parameters} -DCMAKE_BUILD_TYPE=Release"
      system "make"
      system "make install"
    end
  end
end
