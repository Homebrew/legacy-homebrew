class Physfs < Formula
  desc "Library to provide abstract access to various archives"
  homepage "https://icculus.org/physfs/"
  url "https://icculus.org/physfs/downloads/physfs-2.0.3.tar.bz2"
  # Upstream not responding:
  # https://github.com/Homebrew/homebrew/issues/17203
  mirror "https://dl.dropbox.com/u/3252883/Games/physfs-2.0.3.tar.bz2"
  sha256 "ca862097c0fb451f2cacd286194d071289342c107b6fe69079c079883ff66b69"

  depends_on "cmake" => :build

  def install
    mkdir "macbuild" do
      system "cmake", "..",
                      "-DPHYSFS_BUILD_WX_TEST=FALSE",
                      "-DPHYSFS_BUILD_TEST=TRUE",
                      *std_cmake_args
      system "make"
      system "make", "install"
    end
  end
end
