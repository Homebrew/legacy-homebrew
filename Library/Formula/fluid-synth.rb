require 'formula'

class FluidSynth < Formula
  homepage 'http://www.fluidsynth.org'
  url 'https://downloads.sourceforge.net/project/fluidsynth/fluidsynth-1.1.6/fluidsynth-1.1.6.tar.gz'
  sha1 '155de731e72e91e1d4b7f52c33d8171596fbf244'

  bottle do
    cellar :any
    sha1 "599da46ee1e8647c629d0d6b154d689aca459b2f" => :mavericks
    sha1 "6a40b567af7052f3d411c7dbf527978c0a404daf" => :mountain_lion
    sha1 "5cde076c223fa805c4e9fba1d4b7cdf5f5a4b5d5" => :lion
  end

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
