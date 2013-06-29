require 'formula'

class Points2grid < Formula
  homepage 'https://github.com/CRREL/points2grid'
  url 'https://github.com/CRREL/points2grid/archive/1.1.0.tar.gz'
  sha1 'aef7e124b47022bee85bb3585f5996af5cb132e3'

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'pdal'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
