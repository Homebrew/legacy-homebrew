require 'formula'

class Eigen < Formula
  url 'http://bitbucket.org/eigen/eigen/get/3.0.3.tar.bz2'
  homepage 'http://eigen.tuxfamily.org/'
  md5 'bfe750809b54a012a402034a650b4c62'

  depends_on 'cmake' => :build

  def install
    mkdir 'eigen-build'
    Dir.chdir 'eigen-build' do
      system "cmake ..  #{std_cmake_parameters} -DCMAKE_BUILD_TYPE=Release -Dpkg_config_libdir=#{lib}"
      system "make install"
    end
  end
end
