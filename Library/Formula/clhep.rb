require 'formula'

class Clhep < Formula
  homepage 'http://proj-clhep.web.cern.ch/proj-clhep/'
  url 'http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.1.2.2.tgz'
  md5 'b72115137d9871f1b80aed9da01918b0'

  depends_on 'cmake' => :build

  def install
    mkdir 'clhep-build' do
      system "cmake ../CLHEP #{std_cmake_parameters}"
      ENV.j1
      system "make"
      system "make install"
    end
  end
end

