require 'formula'

class Apiextractor < Formula
  homepage 'http://www.pyside.org/docs/apiextractor'
  url 'http://pyside.org/files/apiextractor-0.10.9.tar.bz2'
  md5 '89a3dd539e98fccd0b3f8da881f60395'

  depends_on 'cmake' => :build
  depends_on 'qt'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
