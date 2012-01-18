require 'formula'

class Clay < Formula
  url 'https://github.com/jckarter/clay/tarball/v0.1.0'
  homepage 'https://github.com/jckarter/clay/'
  md5 'fa34b4ecc0ab13047f802b9aac6d850b'
  version '0.1.0'
  head 'git://github.com/jckarter/clay.git'

  depends_on 'cmake' => :build
  depends_on 'llvm'  => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

  def test
    system "clay -e 'println(\"Hello, Clay!\");'"
  end
end
