require 'formula'

class Eigen < Formula
  homepage 'http://eigen.tuxfamily.org/'
  url 'http://bitbucket.org/eigen/eigen/get/3.2.1.tar.bz2'
  sha1 '17aca570d647b25cb3d9dac54b480cfecf402ed9'
  bottle do
    cellar :any
    sha1 "b9fd5b10af6391e035b2e2953389db24a45fb041" => :mavericks
    sha1 "0cc89de9fb2fd1bac03f68375cff7fe453400eac" => :mountain_lion
    sha1 "d0ac8605688ed41f0ae3f7ed9be68000dd222b37" => :lion
  end

  head 'https://bitbucket.org/eigen/eigen', :using => :hg

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
