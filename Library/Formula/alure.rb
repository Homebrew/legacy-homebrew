require 'formula'

class Alure < Formula
  url 'http://kcat.strangesoft.net/alure-releases/alure-1.1.tar.bz2'
  homepage 'http://kcat.strangesoft.net/alure.html'
  md5 'a2f6934d3783c8478c460965a13e4e12'

  depends_on 'cmake'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
