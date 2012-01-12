require 'formula'

class Cminpack < Formula
  url 'http://devernay.free.fr/hacks/cminpack/cminpack-1.1.3.tar.gz'
  homepage 'http://devernay.free.fr/hacks/cminpack/cminpack.html'
  md5 '3573b33d498cc1bf3787a86efbd12c3a'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
