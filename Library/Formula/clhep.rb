require 'formula'

class Clhep < Formula
  url 'http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.1.1.0.tgz'
  homepage 'http://proj-clhep.web.cern.ch/proj-clhep/'
  md5 'f8acb50a9cdb9ac8937fecfcb741ba10'

  def install
    Dir.chdir 'CLHEP' do
      #forcing CXX to be g++ the configure script will find CXX to be g++4.2
      #and will screw up AR and all those
      system "./configure",'CXX=g++', "--disable-debug", "--disable-dependency-tracking",
              "--prefix=#{prefix}"
      system "make"
      ENV.j1 #parallel install seems to fail but parallel build works just fine
      system "make install"
    end
  end
end
