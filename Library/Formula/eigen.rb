require 'formula'

class Eigen < Formula
  homepage 'http://eigen.tuxfamily.org/'
  url 'http://bitbucket.org/eigen/eigen/get/3.0.5.tar.bz2'
  md5 '43070952464a5bf21694e082e7fb8fce'

  depends_on 'cmake' => :build

  def install
    ENV.fortran
    mkdir 'eigen-build' do
      args = std_cmake_args
      args.delete '-DCMAKE_BUILD_TYPE=None'
      args << '-DCMAKE_BUILD_TYPE=Release'

      system "cmake", "..", "-Dpkg_config_libdir=#{lib}", *args
      system "make install"
    end
  end
end
