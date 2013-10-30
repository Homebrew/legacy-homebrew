require 'formula'

class X265 < Formula
  homepage 'http://x265.org'
  url 'https://bitbucket.org/multicoreware/x265/get/0.5.tar.bz2'
  sha1 '7f0a0766083c25b194d2d0f98deafacd29eacaf2'

  head 'https://bitbucket.org/multicoreware/x265', :using => :hg

  depends_on 'yasm' => :build
  depends_on 'cmake' => :build
  depends_on :macos => :lion

  fails_with :gcc do
    build 5666
    cause '-mstackrealign not supported in the 64bit mode'
  end

  fails_with :llvm do
    build 2335
    cause '-mstackrealign not supported in the 64bit mode'
  end

  def install

    args = std_cmake_args
    args.delete '-DCMAKE_BUILD_TYPE=None'
    args << '-DCMAKE_BUILD_TYPE=Release'
    ENV.append 'CXXFLAGS', '-mavx2'

    system "cmake", "source",  *args
    system "make"
    system "make", "install"
  end
end
