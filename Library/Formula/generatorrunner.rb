require 'formula'

class Generatorrunner <Formula
  url 'http://www.pyside.org/files/generatorrunner-0.6.7.tar.bz2'
  homepage 'http://www.pyside.org'
  md5 '4aa42befab58eac50b8b9403b8fe54cc'

  depends_on 'cmake'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
