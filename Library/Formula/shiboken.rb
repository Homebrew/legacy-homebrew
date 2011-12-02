require 'formula'

class Shiboken < Formula
  homepage 'http://www.pyside.org/docs/shiboken'
  url 'http://pyside.org/files/shiboken-1.0.10.tar.bz2'
  md5 'b98e7c35edef95a77594a6d1801c5875'

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
