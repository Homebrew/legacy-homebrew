require 'formula'

class Apiextractor < Formula
  homepage 'http://www.pyside.org/docs/apiextractor'
  url 'http://pyside.org/files/apiextractor-0.10.7.tar.bz2'
  md5 '539be815e7fb09064fefcdb21ad44965'

  depends_on 'cmake' => :build
  depends_on 'qt'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
