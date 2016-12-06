require 'formula'

class Libcuefile < Formula
  url 'http://files.musepack.net/source/libcuefile_r475.tar.gz'
  homepage 'http://www.musepack.net/'
  md5 '1a6ac52e1080fd54f0f59372345f1e4e'
  version 'r475'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
    include.install Dir['./include/cuetools/']
  end
end