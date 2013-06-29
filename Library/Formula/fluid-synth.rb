require 'formula'

class FluidSynth < Formula
  homepage 'http://www.fluidsynth.org'
  url 'http://sourceforge.net/projects/fluidsynth/files/fluidsynth-1.1.6/fluidsynth-1.1.6.tar.gz'
  sha1 '155de731e72e91e1d4b7f52c33d8171596fbf244'

  depends_on 'pkg-config' => :build
  depends_on 'cmake' => :build
  depends_on 'glib'
  depends_on 'libsndfile' => :optional

  def install
    mkdir 'build' do
      system "cmake", "..", "-Denable-framework=OFF", "-DLIB_SUFFIX=", *std_cmake_args
      system "make install"
    end
  end
end
