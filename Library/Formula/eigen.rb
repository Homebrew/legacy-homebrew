require 'formula'

class Eigen < Formula
  homepage 'http://eigen.tuxfamily.org/'
  url 'http://bitbucket.org/eigen/eigen/get/3.1.1.tar.bz2'
  sha1 '9530601b340bdf679d56bd0de63927cab0c5fb82'

  depends_on 'cmake' => :build

  option :universal

  def install
    ENV.fortran
    ENV.universal_binary if build.universal?
    mkdir 'eigen-build' do
      args = std_cmake_args
      args.delete '-DCMAKE_BUILD_TYPE=None'
      args << '-DCMAKE_BUILD_TYPE=Release'
      args << "-Dpkg_config_libdir=#{lib}" << '..'
      system 'cmake', *args
      system 'make install'
    end
  end
end
