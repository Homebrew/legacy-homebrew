require 'formula'

class PysideTools < Formula
  homepage 'http://www.pyside.org'
  url 'http://www.pyside.org/files/pyside-tools-0.2.12.tar.bz2'
  md5 '9a41a565774974a0e2bb60244c996166'

  depends_on 'cmake' => :build

  depends_on 'qt'
  depends_on 'pyside'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
