require 'formula'

class Apiextractor < Formula
  homepage 'http://www.pyside.org/docs/apiextractor'
  url 'http://www.pyside.org/files/apiextractor-0.10.10.tar.bz2'
  md5 '7cdf6bdbf161e15b8bc5e98df86f95ee'

  depends_on 'cmake' => :build

  depends_on 'qt'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
