require 'formula'

class Cminpack < Formula
  homepage 'http://devernay.free.fr/hacks/cminpack/cminpack.html'
  url 'http://devernay.free.fr/hacks/cminpack/cminpack-1.3.0.tar.gz'
  sha1 '8bf19ce37b486707c402a046c33d823c9e359410'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
