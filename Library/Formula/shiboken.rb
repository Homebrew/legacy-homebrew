require 'formula'

class Shiboken < Formula
  homepage 'http://www.pyside.org/docs/shiboken'
  url 'http://pyside.org/files/shiboken-1.0.6.tar.bz2'
  md5 'd52f0dfdc1a63534085547946e4b5fff'

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
