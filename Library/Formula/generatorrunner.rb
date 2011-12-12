require 'formula'

class Generatorrunner < Formula
  homepage 'http://www.pyside.org/docs/generatorrunner'
  url 'http://pyside.org/files/generatorrunner-0.6.15.tar.bz2'
  md5 '88425f176ffc3810307edabc381415c6'

  depends_on 'cmake' => :build

  depends_on 'apiextractor'
  depends_on 'qt'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
