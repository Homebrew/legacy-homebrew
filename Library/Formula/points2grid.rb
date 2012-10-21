require 'formula'

class Points2grid < Formula
  homepage 'https://github.com/CRREL/points2grid'
  url 'https://github.com/CRREL/points2grid/zipball/1.1.0'
  sha1 '31feb8890380964b875ed461b1ed6b769649ee6e'

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'pdal'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
