class Libgroove < Formula
  desc "Streaming audio processing library"
  homepage "https://github.com/andrewrk/libgroove"
  url "https://github.com/andrewrk/libgroove/archive/4.3.0.tar.gz"
  sha256 "76f68896f078a9613d420339ef887ca8293884ad2cd0fbc031d89a6af2993636"
  revision 1

  bottle do
    cellar :any
    sha256 "65ae845d6431bdf04c15c20b262b2a7b3b686d0baec1bffb8e1308af722bf0ae" => :el_capitan
    sha256 "0a6e648e6ef0d01b99577144ebdc8ff283eec60111e33c779ad2ca941ee30f91" => :yosemite
    sha256 "6034bb8923952e2b914d5649e7c2e5bb4b0eccbe3503096744d244f1866e0358" => :mavericks
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
