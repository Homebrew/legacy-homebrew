class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "http://www.fluidsynth.org"
  url "https://downloads.sourceforge.net/project/fluidsynth/fluidsynth-1.1.6/fluidsynth-1.1.6.tar.gz"
  sha256 "50853391d9ebeda9b4db787efb23f98b1e26b7296dd2bb5d0d96b5bccee2171c"

  bottle do
    cellar :any
    sha1 "599da46ee1e8647c629d0d6b154d689aca459b2f" => :mavericks
    sha1 "6a40b567af7052f3d411c7dbf527978c0a404daf" => :mountain_lion
    sha1 "5cde076c223fa805c4e9fba1d4b7cdf5f5a4b5d5" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "libsndfile" => :optional
  depends_on "portaudio" => :optional

  def install
    args = std_cmake_args
    args << "-Denable-framework=OFF" << "-DLIB_SUFFIX="
    args << "-Denable-portaudio=ON" if build.with? "portaudio"
    args << "-Denable-libsndfile=OFF" if build.without? "libsndfile"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/fluidsynth --version")
  end
end
