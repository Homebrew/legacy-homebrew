require 'formula'

class Clhep < Formula
  homepage ''
  url 'http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.1.2.2.tgz'
  md5 'b72115137d9871f1b80aed9da01918b0'

  depends_on 'cmake' => :build

  def install
    mkdir 'clhep-build'
    cd 'clhep-build'
    system "cmake ../CLHEP #{std_cmake_parameters} -DCMAKE_PREFIX_PATH=#{prefix}"
    ENV.j1
    system "make"
    system "make install"
  end
end