require 'formula'

class Cminpack < Formula
  url 'http://devernay.free.fr/hacks/cminpack/cminpack-1.1.3.tar.gz'
  homepage 'http://devernay.free.fr/hacks/cminpack/cminpack.html'
  md5 '3573b33d498cc1bf3787a86efbd12c3a'

  depends_on 'cmake'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

  def test
    # this will fail we won't accept that, make it test the program works!
    system "/usr/bin/false"
  end
end
