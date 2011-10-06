require 'formula'

class Armadillo < Formula
  url 'http://downloads.sourceforge.net/project/arma/armadillo-2.2.3.tar.gz'
  homepage 'http://arma.sourceforge.net/'
  md5 '5966ec93a5840c36765430b61c8d50b2'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

end
