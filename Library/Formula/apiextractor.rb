require 'formula'

class Apiextractor <Formula
  url 'http://www.pyside.org/files/apiextractor-0.10.6.tar.bz2'
  homepage 'http://www.pyside.org'
  md5 '85c3b00d04ad6f5f885caa002b2ae772'

  depends_on 'cmake'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
