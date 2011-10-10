require 'formula'

class Generatorrunner < Formula
  homepage 'http://www.pyside.org/docs/generatorrunner'
  url 'http://pyside.org/files/generatorrunner-0.6.13.tar.bz2'
  md5 'ca214a017404bb1f4775aebcb98e373e'

  depends_on 'cmake' => :build

  depends_on 'apiextractor'
  depends_on 'qt'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
