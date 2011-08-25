require 'formula'

class Shiboken <Formula
  url 'http://www.pyside.org/files/shiboken-1.0.6.tar.bz2'
  homepage 'http://www.pyside.org'
  md5 'd52f0dfdc1a63534085547946e4b5fff'

  depends_on 'cmake'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
