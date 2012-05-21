require 'formula'

class Clay < Formula
  homepage 'http://claylabs.com/clay/'
  url 'https://github.com/jckarter/clay/tarball/v0.1.0'
  md5 'fa34b4ecc0ab13047f802b9aac6d850b'

  head 'https://github.com/jckarter/clay.git'

  depends_on 'cmake' => :build
  depends_on 'llvm'  => :build

  def install
    system "cmake #{std_cmake_parameters} ."
    system "make install"
  end

  def test
    system "#{bin}/clay", "-e", "println(\"Hello, Clay!\");"
  end
end
