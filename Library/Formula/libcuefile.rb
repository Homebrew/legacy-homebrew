require 'formula'

class Libcuefile < Formula
  homepage 'http://www.musepack.net/'
  url 'http://files.musepack.net/source/libcuefile_r475.tar.gz'
  sha1 'd7363882384ff75809dc334d3ced8507b81c6051'
  version 'r475'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
    include.install 'include/cuetools/'
  end
end
