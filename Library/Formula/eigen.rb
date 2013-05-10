require 'formula'

class Eigen < Formula
  homepage 'http://eigen.tuxfamily.org/'
  url 'http://bitbucket.org/eigen/eigen/get/3.1.3.tar.bz2'
  sha1 'd7190ee6228998f64566395d3973f0a8eb31d7c6'

  depends_on 'cmake' => :build

  option :universal

  def install
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
