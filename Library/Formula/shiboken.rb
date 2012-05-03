require 'formula'

class Shiboken < Formula
  homepage 'http://www.pyside.org/docs/shiboken'
  url 'http://www.pyside.org/files/shiboken-latest.tar.bz2'
  md5 'fa451b6c4f3e06cce283a84550a96fd2'

  depends_on 'cmake' => :build
  depends_on 'qt'

  def install
    # Building the tests also runs them. Not building and running tests cuts
    # install time in half.
    mkdir 'build'
    chdir 'build' do
      system "cmake .. #{std_cmake_parameters} -DBUILD_TESTS=OFF"
      system "make install"
    end
  end
end
