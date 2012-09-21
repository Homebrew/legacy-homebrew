require 'formula'

class Armadillo < Formula
  homepage 'http://arma.sourceforge.net/'
  url 'http://sourceforge.net/projects/arma/files/armadillo-3.4.1.tar.gz'
  sha1 '16f11ee6e7a545581ab239e7f826e14d7d1c2e3a'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
