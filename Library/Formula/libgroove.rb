require "formula"

class Libgroove < Formula
  homepage "https://github.com/andrewrk/libgroove"
  url "https://github.com/andrewrk/libgroove/archive/4.2.1.tar.gz"
  sha1 "cdcf4109266bb5eb38d62945891d37d907c3ccd3"

  bottle do
    cellar :any
    sha1 "7ebecaca18d390525c2d668df4ca84aad82b5033" => :mavericks
  end

  depends_on :macos => :mavericks
  depends_on "cmake" => :build
  depends_on "ffmpeg" => "with-libvorbis"
  depends_on "chromaprint"
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
