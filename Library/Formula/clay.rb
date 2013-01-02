require 'formula'

class Clay < Formula
  homepage 'http://claylabs.com/clay/'
  url 'https://github.com/jckarter/clay/tarball/v0.1.2'
  sha1 '1c7de85a36b4516c0cf5ba7f413d748d1c37c9b4'

  head 'https://github.com/jckarter/clay.git'

  depends_on 'cmake' => :build
  depends_on 'llvm'  => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end

  def test
    system "#{bin}/clay", "-e", "println(\"Hello, Clay!\");"
  end
end
