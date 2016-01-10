class GameMusicEmu < Formula
  desc "Videogame music file emulator collection"
  homepage "https://code.google.com/p/game-music-emu/"
  url "https://game-music-emu.googlecode.com/files/game-music-emu-0.6.0.tar.bz2"
  sha256 "506e81d0c61e1a26d503fbf5351503e0b31f9fbb374cb1f09979758b46a24987"

  head "http://game-music-emu.googlecode.com/svn/trunk/"

  bottle do
    cellar :any
    sha256 "ae3d3d693ce6114a264f0a323172c995f554060cbc70e3e6195f3f4734486432" => :yosemite
    sha256 "e98e08a428bff3aef00f3c48e999d6b0d1753242f319b2998b62a48f9c00c629" => :mavericks
    sha256 "7877316c725c649b0f7a2245de83895a800ac48f12a86a5868e08b7517460fa5" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gme/gme.h>
      int main(void)
      {
        Music_Emu* emu;
        gme_err_t error;

        error = gme_open_data((void*)0, 0, &emu, 44100);

        if (error == gme_wrong_file_type) {
          return 0;
        } else {
          return -1;
        }
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}",
                   "-lgme", "-o", "test", *ENV.cflags.to_s.split

    system "./test"
  end
end
