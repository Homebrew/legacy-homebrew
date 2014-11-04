require "formula"

class Liblastfm < Formula
  homepage "https://github.com/lastfm/liblastfm/"
  url "https://github.com/lastfm/liblastfm/archive/1.0.9.tar.gz"
  sha1 "4a6323538a26c5ea2080a8ebe58e4407dbc42397"

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
