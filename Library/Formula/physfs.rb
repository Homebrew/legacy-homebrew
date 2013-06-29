require 'formula'

class Physfs < Formula
  homepage 'http://icculus.org/physfs/'
  url 'http://icculus.org/physfs/downloads/physfs-2.0.3.tar.bz2'
  # Upstream not responding:
  # https://github.com/mxcl/homebrew/issues/17203
  mirror 'https://dl.dropbox.com/u/3252883/Games/physfs-2.0.3.tar.bz2'
  sha1 '327308c777009a41bbabb9159b18c4c0ac069537'

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
