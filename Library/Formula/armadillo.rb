require 'formula'

class Armadillo < Formula
  homepage 'http://arma.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/arma/armadillo-3.0.3.tar.gz'
  sha1 '44e5d48798c6b3ce81c2e51e8d34c332b3d0af99'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    system "cmake #{std_cmake_parameters} ."
    system "make install"
  end
end
