require 'formula'

class Generatorrunner <Formula
  url 'http://www.pyside.org/files/generatorrunner-0.6.12.tar.bz2'
  homepage 'http://www.pyside.org'
  md5 '39bf1f2e93fdec434d268cc6fb9d9ebf'

  depends_on 'cmake'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
