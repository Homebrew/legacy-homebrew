require 'formula'

class Points2grid < Formula
  homepage 'https://github.com/CRREL/points2grid'
  url 'https://github.com/CRREL/points2grid/zipball/1.1.0'
  md5 '39a8426675d6f5cb2414683c737b13bf'

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'pdal'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
