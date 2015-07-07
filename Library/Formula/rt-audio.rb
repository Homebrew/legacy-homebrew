class RtAudio < Formula
  desc "API for realtime audio input/output"
  homepage "https://www.music.mcgill.ca/~gary/rtaudio/"
  url "https://www.music.mcgill.ca/~gary/rtaudio/release/rtaudio-4.1.1.tar.gz"
  sha256 "e279e01243ffddc0ab1640ed2f580b48c2a79ffab3e21c64845f586a9a772598"

  head "https://github.com/thestk/rtaudio.git"

  bottle do
    cellar :any
    sha256 "1ad4fce27b7f11e88bc3d4d958d9f9a9add117dc5ad8fb0a225edcde89b6bce6" => :yosemite
    sha256 "2ac64592ba5e1c9f5dacd5774d25fea7f968cb632ae3ea48e8d3f8c95fad1420" => :mavericks
    sha256 "32fb53538dceba914cb8369e25a8d74c6ebf115f237a11dadb618e4339653a32" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      lib.install "librtaudio_static.a", "librtaudio.dylib"
    end
    include.install "RtAudio.h", Dir["include/*"]
    prefix.install "contrib", "tests"
    doc.install Dir["doc/*"]
  end

  test do
    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lrtaudio",
           prefix/"tests/testall.cpp", "-o", "test"
    system "./test"
  end
end
