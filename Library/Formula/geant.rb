require 'formula'

class Geant < Formula
  homepage 'http://geant4.cern.ch'
  url 'http://geant4.cern.ch/support/source/geant4.10.00.tar.gz'
  sha1 'cd91d0b50aab119c85a05c7a44b6fac9168af02d'

  depends_on 'cmake' => :build
  depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on 'clhep'

  def install
    mkdir 'geant-build' do
      system "cmake", "../",
                      "-DCMAKE_PREFIX_PATH=#{prefix}",
                      "-DGEANT4_INSTALL_DATA=ON",
                      "-DGEANT4_USE_OPENGL_X11=ON",
                      "-DGEANT4_USE_RAYTRACER_X11=ON",
                      "-DGEANT4_BUILD_EXAMPLE=ON",
                      "-DGEANT4_USE_SYSTEM_CLHEP=ON",
                      *std_cmake_args
      system "make install" # if this fails, try separate make/make install steps
    end
  end
end
