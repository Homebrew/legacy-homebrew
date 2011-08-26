require 'formula'

class Generatorrunner < Formula
  homepage 'http://www.pyside.org/docs/generatorrunner'
  url 'http://pyside.org/files/generatorrunner-0.6.12.tar.bz2'
  md5 '39bf1f2e93fdec434d268cc6fb9d9ebf'

  depends_on 'cmake' => :build

  depends_on 'apiextractor'
  depends_on 'qt'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
