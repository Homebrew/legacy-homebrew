require 'formula'

class Physfs < Formula
  homepage 'http://icculus.org/physfs/'
  url 'http://icculus.org/physfs/downloads/physfs-2.0.2.tar.gz'
  sha1 '2d3d3cc819ad26542d34451f44050b85635344d0'

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
