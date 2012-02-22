require 'formula'

class Armadillo < Formula
  homepage 'http://arma.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/arma/armadillo-2.4.3.tar.gz'
  md5 'b237a869ca4535a45ac420853f779c77'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    system "cmake #{std_cmake_parameters} ."
    system "make install"
  end
end
