require 'formula'

class Clhep < Formula
  homepage 'http://proj-clhep.web.cern.ch/proj-clhep/'
  url 'http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.1.2.5.tgz'
  sha1 '6d7b6b260688bdf516ce414dbd74473e8aa98865'

  depends_on 'cmake' => :build

  def install
    mkdir 'clhep-build' do
      system "cmake", "../CLHEP",
                      "-DCMAKE_PREFIX_PATH=#{prefix}",
                      *std_cmake_args
      system "make install"
    end
  end
end
