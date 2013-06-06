require 'formula'

class Pdal < Formula
  homepage 'http://pointcloud.org'
  url 'https://github.com/PDAL/PDAL/archive/0.1.0.tar.gz'
  sha1 '74f3f5d8b58c52b7eb2afe260a0020b7c4a6906e'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
