require 'formula'

class Clhep < Formula
  homepage 'http://proj-clhep.web.cern.ch/proj-clhep/'
  url 'http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.1.3.1.tgz'
  sha1 '3ef0b7410d71ca25bb2f5b5ba6d928a338e30e6e'

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
