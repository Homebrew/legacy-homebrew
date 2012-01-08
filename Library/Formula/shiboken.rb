require 'formula'

class Shiboken < Formula
  homepage 'http://www.pyside.org/docs/shiboken'
  url 'http://pyside.org/files/shiboken-1.1.0.tar.bz2'
  md5 '9c9d696c8c426fb5abf28a6bd3759558'

  depends_on 'cmake' => :build

  depends_on 'generatorrunner'

  def install
    # Building the tests also runs them. Not building and running tests cuts
    # install time in half.
    system "cmake . #{std_cmake_parameters} -DBUILD_TESTS=OFF"
    system "make install"
  end
end
