require 'formula'

class Physfs < Formula
  url 'http://icculus.org/physfs/downloads/physfs-2.0.2.tar.gz'
  homepage 'http://icculus.org/physfs/'
  md5 '4e8927c3d30279b03e2592106eb9184a'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters} -DPHYSFS_BUILD_WX_TEST=FALSE"
    system "make install"
  end
end
