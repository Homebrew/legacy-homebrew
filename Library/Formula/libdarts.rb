require 'formula'

class Uchardet < Formula
  homepage 'https://github.com/BYVoid/libdarts'
  url 'https://github.com/BYVoid/libdarts/archive/v0.32-1.tar.gz'
  sha1 '0c560769ae3d935f88de1e277fd2408792c45d3a'

  depends_on 'cmake' => :build

  def install
    args = std_cmake_args
    args << "-DCMAKE_INSTALL_NAME_DIR=#{lib}"
    system "cmake", '.', *args
    system "make install"
  end
end
