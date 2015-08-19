class GameMusicEmu < Formula
  desc "Videogame music file emulator collection"
  homepage "https://code.google.com/p/game-music-emu/"
  url "https://game-music-emu.googlecode.com/files/game-music-emu-0.6.0.tar.bz2"
  sha256 "506e81d0c61e1a26d503fbf5351503e0b31f9fbb374cb1f09979758b46a24987"

  head "http://game-music-emu.googlecode.com/svn/trunk/"

  bottle do
    cellar :any
    sha1 "ceef76e75ac6ba2cc10f3d909fa42884a54a7833" => :yosemite
    sha1 "bc298aea7a024e60411c1cb2f6f778656dad7bc1" => :mavericks
    sha1 "5f5ceca1e279614d32a06134d0f35585fd0d2446" => :mountain_lion
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
