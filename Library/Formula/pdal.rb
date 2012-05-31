require 'formula'

class Pdal < Formula
  homepage 'http://pointcloud.org'
  url 'https://github.com/PDAL/PDAL/zipball/0.1.0'
  md5 'fd5766b2da2337971cbf0e465dc5bd50'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
