require 'formula'

class Armadillo < Formula
  homepage 'http://arma.sourceforge.net/'
  url 'http://sourceforge.net/projects/arma/files/armadillo-3.4.2.tar.gz'
  sha1 'de3d2a6005d2433f0630f4ef0885a0a8712968dd'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
