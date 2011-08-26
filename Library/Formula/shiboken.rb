require 'formula'

class Shiboken < Formula
  homepage 'http://www.pyside.org/docs/shiboken'
  url 'http://pyside.org/files/shiboken-1.0.5.tar.bz2'
  md5 'e9249ab88a5ba67183a165d11143c894'

  depends_on 'cmake' => :build

  depends_on 'generatorrunner'
  depends_on 'apiextractor'
  depends_on 'qt'

  def install
    # Building the tests also runs them. Not building and running tests cuts
    # install time in half.
    system "cmake . #{std_cmake_parameters} -DBUILD_TESTS=OFF"
    system "make install"
  end
end
