class Liblastfm < Formula
  desc "Libraries for Last.fm site services"
  homepage "https://github.com/lastfm/liblastfm/"
  url "https://github.com/lastfm/liblastfm/archive/1.0.9.tar.gz"
  sha256 "5276b5fe00932479ce6fe370ba3213f3ab842d70a7d55e4bead6e26738425f7b"

  bottle do
    sha256 "6d6010150ff154400622bb6e95d1017ece5627b1eb845ff58d0753767f0d7965" => :yosemite
    sha256 "e9e9d6f323fcf3d7ccd07bed4c25bdb8c6053769c24729486868f7f2c9f7af17" => :mavericks
    sha256 "7083be85d79ee12c621e380ae149d5105a1117de4733eca024d64ef72d435cb5" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "qt"
  depends_on "fftw"
  depends_on "libsamplerate"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
