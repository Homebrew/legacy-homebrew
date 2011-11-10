require 'formula'

class Generatorrunner < Formula
  homepage 'http://www.pyside.org/docs/generatorrunner'
  url 'http://pyside.org/files/generatorrunner-0.6.14.tar.bz2'
  md5 '6413d4417939c7347d0e13a1e6bc608c'

  depends_on 'cmake' => :build

  depends_on 'apiextractor'
  depends_on 'qt'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
