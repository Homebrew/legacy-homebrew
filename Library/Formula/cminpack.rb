require 'formula'

class Cminpack < Formula
  homepage 'http://devernay.free.fr/hacks/cminpack/cminpack.html'
  url 'http://devernay.free.fr/hacks/cminpack/cminpack-1.1.3.tar.gz'
  md5 '3573b33d498cc1bf3787a86efbd12c3a'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
