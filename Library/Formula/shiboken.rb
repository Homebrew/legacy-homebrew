require 'formula'

class Shiboken < Formula
  homepage 'http://www.pyside.org/docs/shiboken'
  url 'http://pyside.org/files/shiboken-1.0.7.tar.bz2'
  md5 'b932c66a49145894c0af556030ac90ac'

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
