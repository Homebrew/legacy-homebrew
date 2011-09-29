require 'formula'

class Clhep < Formula
  homepage 'http://proj-clhep.web.cern.ch/proj-clhep/'
  url 'http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.1.1.0.tgz'
  md5 'f8acb50a9cdb9ac8937fecfcb741ba10'

  depends_on 'cmake' => :build

  def install
    mkdir 'clhep-build' do
      system "cmake ../CLHEP  #{std_cmake_parameters} -DCMAKE_PREFIX_PATH=#{prefix}"
      ENV.j1
      system "make"
      system "make install"
    end
  end
end
