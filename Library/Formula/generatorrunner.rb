require 'formula'

class Generatorrunner < Formula
  homepage 'http://www.pyside.org/docs/generatorrunner'
  url 'http://pyside.org/files/generatorrunner-0.6.11.tar.bz2'
  md5 '6ce05392bc75a965a28980fa03cc69e3'

  depends_on 'cmake' => :build

  depends_on 'apiextractor'
  depends_on 'qt'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
