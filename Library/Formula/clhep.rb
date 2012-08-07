require 'formula'

class Clhep < Formula
  homepage 'http://proj-clhep.web.cern.ch/proj-clhep/'
  url 'http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.1.2.4.tgz'
  sha1 '9a1bf732bfe8e1b7d461243006e0a521f2721aa6'

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
