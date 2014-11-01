require "formula"

class Liblastfm < Formula
  homepage "https://github.com/lastfm/liblastfm/"
  url "https://github.com/lastfm/liblastfm/archive/1.0.9.tar.gz"
  sha1 "4a6323538a26c5ea2080a8ebe58e4407dbc42397"

  bottle do
    revision 1
    sha1 "e1e5a13e15705984ad5cfc8eddbd9c9e5b253619" => :yosemite
    sha1 "51544d5091c626ad854c06c3a9c80acfef94cf77" => :mavericks
    sha1 "8ca49c976b13020ea6aed69b4364c24a30783ba7" => :mountain_lion
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
