require 'formula'

class Apiextractor < Formula
  homepage 'http://www.pyside.org/docs/apiextractor'
  url 'http://pyside.org/files/apiextractor-0.10.5.tar.bz2'
  md5 'cb9c14dbe5e9a2e4e8a960ebed36d9cb'

  depends_on 'cmake' => :build
  depends_on 'qt'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
