class Dsd < Formula
  desc "Decoder for several digital speech formats"
  homepage "http://wiki.radioreference.com/index.php/Digital_Speech_Decoder_%28software_package%29"
  head "https://github.com/szechyjs/dsd.git"
  url "https://github.com/szechyjs/dsd/archive/v1.6.0.tar.gz"
  sha256 "44fa3ae108d2c11b4b67388d37fc6a63e8b44fc72fdd5db7b57d9eb045a9df58"

  bottle do
    cellar :any
    sha1 "078526fcb83180832b34282f717a9811f54d6d85" => :yosemite
    sha1 "a86e78c5668c89567b9c0c3a46c630268901f4d7" => :mavericks
    sha1 "7c835fae91c450e912811b7c5d3c173564283623" => :mountain_lion
  end

  patch do
    # Fixes build on MacOS X.
    url "https://github.com/szechyjs/dsd/commit/e40c32d8addf3ab94dae42d8c0fcf9ef27e453c2.diff"
    sha256 "58d88fd58c32c63920ab9dcfe2a1eb4de6f3e688062ab14dcb3f4e259d735923"
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
    system "dsd", "-h"
  end
end
