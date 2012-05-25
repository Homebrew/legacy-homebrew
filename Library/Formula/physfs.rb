require 'formula'

class Physfs < Formula
  homepage 'http://icculus.org/physfs/'
  url 'http://icculus.org/physfs/downloads/physfs-2.0.2.tar.gz'
  md5 '4e8927c3d30279b03e2592106eb9184a'

  depends_on 'cmake' => :build

  def install
    mkdir 'macbuild' do
      system "cmake", "..",
                      "-DPHYSFS_BUILD_WX_TEST=FALSE",
                      "-DPHYSFS_BUILD_TEST=TRUE",
                      *std_cmake_args
      system "make"
      system "make install"
    end
  end
end
