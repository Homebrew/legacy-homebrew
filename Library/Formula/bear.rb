require 'formula'

class Bear < Formula
  homepage 'https://github.com/rizsotto/Bear'
  url 'https://github.com/rizsotto/Bear/archive/1.2.tar.gz'
  sha1 'ad85baab269506750b6657ddfd16174fa69a3540'

  head 'https://github.com/rizsotto/Bear.git'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'libconfig'

  def install
    mkdir 'build' do
      system 'cmake', '..', '-DCMAKE_BUILD_TYPE=Release', *std_cmake_args
      system 'make', 'install'
    end
  end
end
