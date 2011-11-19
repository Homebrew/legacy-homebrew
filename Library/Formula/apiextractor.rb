require 'formula'

class Apiextractor < Formula
  homepage 'http://www.pyside.org/docs/apiextractor'
  url 'http://pyside.org/files/apiextractor-0.10.8.tar.bz2'
  md5 'ddf42bdd6becae602feacf8a1b190425'

  depends_on 'cmake' => :build
  depends_on 'qt'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
