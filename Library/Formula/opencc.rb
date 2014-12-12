require 'formula'

class Opencc < Formula
  homepage 'https://github.com/BYVoid/OpenCC'
  url 'http://dl.bintray.com/byvoid/opencc/opencc-1.0.1.tar.gz'
  sha1 'e5cdedef5d9d96f5046a0f44f3004611330ded4a'

  bottle do
    sha1 "8ccf8db44595debc423220a40f0fe6d715bd60ef" => :yosemite
    sha1 "cb24320dd8415a6b06df2e82ae76e05f2e9396d7" => :mavericks
    sha1 "98a43a46a22da47a206e0a04ab98e87990c72bbe" => :mountain_lion
  end

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
