require 'formula'

class Clhep < Formula
  homepage 'http://proj-clhep.web.cern.ch/proj-clhep/'
  url 'http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.1.2.2.tgz'
  sha1 '374340e316c192c211db36c4cd3f29407cc75318'

  depends_on 'cmake' => :build

  def install
    mkdir 'clhep-build' do
      system "cmake #{std_cmake_parameters} -DCMAKE_PREFIX_PATH='#{prefix}' ../CLHEP"
      system "make install"
    end
  end
end
