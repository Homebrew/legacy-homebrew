require 'formula'

class Armadillo < Formula
  homepage 'http://arma.sourceforge.net/'
  url 'http://sourceforge.net/projects/arma/files/armadillo-3.6.1.tar.gz'
  sha1 'c3b34f2c240ca1da6e9e3728dc1ebd2d197a2071'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
