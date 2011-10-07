require 'formula'

class Eigen < Formula
  url 'http://bitbucket.org/eigen/eigen/get/3.0.2.tar.bz2'
  homepage 'http://eigen.tuxfamily.org/'
  md5 '45ee4ac26b25ae7152bf1e7754497971'

  depends_on 'cmake' => :build

  def install
    # http://eigen.tuxfamily.org/bz/show_bug.cgi?id=338
    inreplace 'CMakeLists.txt', 'DESTINATION share/pkgconfig', 'DESTINATION lib/pkgconfig'

    mkdir 'eigen-build'
    Dir.chdir 'eigen-build' do
      system "cmake ..  #{std_cmake_parameters} -DCMAKE_BUILD_TYPE=Release"
      system "make install"
    end
  end
end
