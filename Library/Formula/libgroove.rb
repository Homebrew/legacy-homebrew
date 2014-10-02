require "formula"

class Libgroove < Formula
  homepage "https://github.com/andrewrk/libgroove"
  url "https://github.com/andrewrk/libgroove/archive/4.2.0.tar.gz"
  sha1 "1d60506bf9c99cefbbe5c2eea24fd0c1c39c39f5"

  bottle do
    cellar :any
    sha1 "ee1764dec529305eba952244884d880c495762e6" => :mavericks
  end

  depends_on :macos => :mavericks
  depends_on "cmake" => :build
  depends_on "chromaprint"
  depends_on "libav" => ["with-libvorbis"]
  depends_on "libebur128"
  depends_on "sdl2"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <groove/groove.h>
      int main() {
        groove_init();
        groove_version();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lgroove", "-o", "test"
    system "./test"
  end
end
