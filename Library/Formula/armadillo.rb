require 'formula'

class Armadillo < Formula
  homepage 'http://arma.sourceforge.net/'
  url 'http://sourceforge.net/projects/arma/files/armadillo-3.4.3.tar.gz'
  sha1 'a89adc51fa01640bfe463d9120cae57b2c073f8e'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
