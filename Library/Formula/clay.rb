require 'formula'

class Clay < Formula
  homepage 'http://claylabs.com/clay/'
  url 'https://github.com/jckarter/clay/tarball/v0.1.2'
  md5 '73cf7b8c44dd006c01ec3249edd86a77'

  head 'https://github.com/jckarter/clay.git'

  depends_on 'cmake' => :build
  # Clay 0.1.2 depends on LLVM 3.1 that is installed by default on Mountain Lion
  #depends_on 'llvm'  => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end

  def test
    system "#{bin}/clay", "-e", "println(\"Hello, Clay!\");"
  end
end
