require 'formula'

class Armadillo < Formula
  homepage 'http://arma.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/arma/armadillo-3.0.2.tar.gz'
  md5 '2605d9fda2b8113e4d2afbeb104f953d'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    system "cmake #{std_cmake_parameters} ."
    system "make install"
  end
end
