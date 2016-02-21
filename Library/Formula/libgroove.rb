class Libgroove < Formula
  desc "Streaming audio processing library"
  homepage "https://github.com/andrewrk/libgroove"
  url "https://github.com/andrewrk/libgroove/archive/4.3.0.tar.gz"
  sha256 "76f68896f078a9613d420339ef887ca8293884ad2cd0fbc031d89a6af2993636"
  revision 1

  bottle do
    cellar :any
    sha256 "0aed4c4465b5db098f23fc8ce8c4e9e09987c98ccdfced38499f2f0d81013455" => :yosemite
    sha256 "bf744cb535945d763a3870e4b618ba61419bd6093b406ad803e9b03f836285be" => :mavericks
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
