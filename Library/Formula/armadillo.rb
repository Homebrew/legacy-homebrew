require 'formula'

class Armadillo < Formula
  url 'http://downloads.sourceforge.net/project/arma/armadillo-2.4.2.tar.gz'
  homepage 'http://arma.sourceforge.net/'
  md5 '9b5c255a24ca6c2fe507797b9bad5d2e'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

end
