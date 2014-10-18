require 'formula'

class Opencc < Formula
  homepage 'https://github.com/BYVoid/OpenCC'
  url 'http://dl.bintray.com/byvoid/opencc/opencc-1.0.1.tar.gz'
  sha1 'e5cdedef5d9d96f5046a0f44f3004611330ded4a'

  depends_on 'cmake' => :build

  needs :cxx11

  def install
    ENV.cxx11
    args = std_cmake_args
    args << '-DBUILD_DOCUMENTATION:BOOL=OFF'
    system 'cmake', '.', *args
    system 'make'
    system 'make install'
  end
end
