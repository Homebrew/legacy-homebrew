require 'formula'

class Embree < Formula
  homepage 'http://embree.github.io'
  url 'http://github.com/embree/embree/archive/v2.0.zip'
  sha1 '0a33c4889c08f9edb0fa7af5668232e98e9f99e9'

  depends_on 'cmake' => :build

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DCOMPILER:STRING=CLANG" if ENV.compiler == :clang
    system "cmake", ".", *cmake_args
    system "make embree"
    include.install "embree"
    system "find", "#{include}/embree", "-type", "f", "-not", "-name", "*.h", "-exec", "rm", "{}", "\;"
    lib.install Dir["*.a"]
  end
end
