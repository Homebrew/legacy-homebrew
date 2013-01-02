require 'formula'

class Pdal < Formula
  homepage 'http://pointcloud.org'
  url 'https://github.com/PDAL/PDAL/zipball/0.1.0'
  sha1 'd0cc3d2ea5909d51e0ce1e451b4236819de4a0b7'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
