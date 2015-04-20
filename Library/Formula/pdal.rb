require 'formula'

class Pdal < Formula
  homepage 'http://pointcloud.org'
  url 'https://github.com/PDAL/PDAL/archive/0.9.8.tar.gz'
  sha1 '6a6a76e6531473541746c19154630ff403099547'

  head 'https://github.com/PDAL/PDAL.git'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
