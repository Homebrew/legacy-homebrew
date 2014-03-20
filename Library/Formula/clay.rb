require 'formula'

class Clay < Formula
  homepage 'http://claylabs.com/clay/'
  url 'https://github.com/jckarter/clay/archive/v0.1.2.tar.gz'
  sha1 'cd557a5ccaca17fd8ec83651f8df3e5405c4f855'

  head 'https://github.com/jckarter/clay.git'

  depends_on 'cmake' => :build
  depends_on 'llvm'  => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end

  test do
    system "#{bin}/clay", "-e", "println(\"Hello, Clay!\");"
  end
end
