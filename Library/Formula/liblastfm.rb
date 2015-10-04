class Liblastfm < Formula
  desc "Libraries for Last.fm site services"
  homepage "https://github.com/lastfm/liblastfm/"
  url "https://github.com/lastfm/liblastfm/archive/1.0.9.tar.gz"
  sha256 "5276b5fe00932479ce6fe370ba3213f3ab842d70a7d55e4bead6e26738425f7b"

  bottle do
    sha1 "1e919a51bc85ccc07753feec683ff8b9b96e4f0d" => :yosemite
    sha1 "efe8b8353f833aa7162602f00f4f28b6d56e770f" => :mavericks
    sha1 "7d69b0a7013c97a78fcbba626f6d33dbb734f180" => :mountain_lion
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
