class Dsd < Formula
  desc "Decoder for several digital speech formats"
  homepage "https://wiki.radioreference.com/index.php/Digital_Speech_Decoder_%28software_package%29"
  head "https://github.com/szechyjs/dsd.git"

  stable do
    url "https://github.com/szechyjs/dsd/archive/v1.6.0.tar.gz"
    sha256 "44fa3ae108d2c11b4b67388d37fc6a63e8b44fc72fdd5db7b57d9eb045a9df58"

    patch do
      # Fixes build on OS X.
      url "https://github.com/szechyjs/dsd/commit/e40c32d8addf3ab94dae42d8c0fcf9ef27e453c2.diff"
      sha256 "58d88fd58c32c63920ab9dcfe2a1eb4de6f3e688062ab14dcb3f4e259d735923"
    end
  end

  bottle do
    cellar :any
    revision 1
    sha256 "b4dd0514fb32269f4c92d02e8057b8d6d6cd583c82cfd8509a29cb7b770a9b30" => :el_capitan
    sha256 "545b456a92ba6da6054dc4dc54d456373d5be7b6429a015ccf8cd8278f65ee2e" => :yosemite
    sha256 "02f0f0e3d5cbd791145706ea1019bda93c1062210df9c80aa0c532d21f1e584e" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "libsndfile"
  depends_on "mbelib"
  depends_on "itpp"
  depends_on "portaudio"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"dsd", "-h"
  end
end
