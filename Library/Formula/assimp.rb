require 'formula'

class Assimp < Formula
  homepage 'http://assimp.sourceforge.net/'
  url "https://downloads.sourceforge.net/project/assimp/assimp-3.1/assimp-3.1.1_no_test_models.zip"
  sha1 "d7bc1d12b01d5c7908d85ec9ff6b2d972e565e2d"
  version "3.1.1"

  head 'https://github.com/assimp/assimp.git'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
