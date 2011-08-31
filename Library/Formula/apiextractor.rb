require 'formula'

class Apiextractor < Formula
  homepage 'http://www.pyside.org/docs/apiextractor'
  url 'http://pyside.org/files/apiextractor-0.10.6.tar.bz2'
  md5 '85c3b00d04ad6f5f885caa002b2ae772'

  depends_on 'cmake' => :build
  depends_on 'qt'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
