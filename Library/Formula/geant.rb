require 'formula'

class Geant < Formula
  homepage 'http://geant4.cern.ch'
  url 'http://geant4.cern.ch/support/source/geant4.10.00.tar.gz'
  sha1 'cd91d0b50aab119c85a05c7a44b6fac9168af02d'

  option 'with-g3tog4', 'Use G3toG4 Library'

  depends_on 'cmake' => :build
  depends_on :x11
  depends_on 'clhep'
  depends_on 'qt' => :optional

  def install
    mkdir 'geant-build' do
      args = %W[
               ../
               -DGEANT4_INSTALL_DATA=ON
               -DGEANT4_USE_OPENGL_X11=ON
               -DGEANT4_USE_RAYTRACER_X11=ON
               -DGEANT4_BUILD_EXAMPLE=ON
               -DGEANT4_USE_SYSTEM_CLHEP=ON
             ]

      args << '-DGEANT4_USE_QT=ON' if build.with? 'qt'
      args << '-DGEANT4_USE_G3TOG4=ON' if build.with? 'g3tog4'
      args.concat(std_cmake_args)
      system "cmake", *args
      system "make install"
    end
  end
end
