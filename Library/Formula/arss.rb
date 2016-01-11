class Arss < Formula
  desc "Analyze a sound file into a spectrogram"
  homepage "http://arss.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arss/arss/0.2.3/arss-0.2.3-src.tar.gz"
  sha256 "e2faca8b8a3902226353c4053cd9ab71595eec6ead657b5b44c14b4bef52b2b2"

  depends_on "cmake" => :build
  depends_on "fftw"

  def install
    cd "src" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end
end
