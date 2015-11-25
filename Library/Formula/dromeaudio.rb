class Dromeaudio < Formula
  desc "Small C++ audio manipulation and playback library"
  homepage "https://github.com/joshb/dromeaudio/"
  url "https://github.com/joshb/DromeAudio/archive/v0.3.0.tar.gz"
  sha256 "d226fa3f16d8a41aeea2d0a32178ca15519aebfa109bc6eee36669fa7f7c6b83"

  head "https://github.com/joshb/dromeaudio.git"

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
