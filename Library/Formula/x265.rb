require 'formula'

class X265 < Formula
  homepage 'http://x265.org'
  url 'https://bitbucket.org/multicoreware/x265/get/0.7.tar.bz2'
  sha1 'c9bec77b86ba131211c7901542228c3d52abe065'

  head 'https://bitbucket.org/multicoreware/x265', :using => :hg

  depends_on 'yasm' => :build
  depends_on 'cmake' => :build
  depends_on :macos => :lion

  def install

    args = std_cmake_args
    args.delete '-DCMAKE_BUILD_TYPE=None'
    args << '-DCMAKE_BUILD_TYPE=Release'

    system "cmake", "source",  *args
    system "make", "install"
  end
end
