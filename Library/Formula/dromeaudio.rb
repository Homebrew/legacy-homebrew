class Dromeaudio < Formula
  desc "Small C++ audio manipulation and playback library"
  homepage "https://github.com/joshb/dromeaudio/"
  url "https://github.com/joshb/DromeAudio/archive/v0.3.0.tar.gz"
  sha256 "d226fa3f16d8a41aeea2d0a32178ca15519aebfa109bc6eee36669fa7f7c6b83"

  head "https://github.com/joshb/dromeaudio.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "79eba06cdf2c4c56a1ffb1788e516e7436234ffafa9b7aca6709f547987b4928" => :el_capitan
    sha256 "9c7ec4059a1ef3c42bad35ab17d08d9da3cd3df40bbdf22d590f86d3a147f29a" => :yosemite
    sha256 "01d67d410a4c4c83ae46b885ba7d7a344fdb9f0ca737d13395df5382bd4d81aa" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    # install FindDromeAudio.cmake under share/cmake/Modules/
    inreplace "share/CMakeLists.txt", "${CMAKE_ROOT}", "#{share}/cmake"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/DromeAudioPlayer", test_fixtures("test.mp3")
  end
end
