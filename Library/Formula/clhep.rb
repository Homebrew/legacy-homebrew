require 'formula'

class Clhep < Formula
  homepage 'http://proj-clhep.web.cern.ch/proj-clhep/'
  url 'http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.1.4.1.tgz'
  sha1 '8e47b348e071e4dbaeea89ce60f3b32c3b0c2f47'

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
