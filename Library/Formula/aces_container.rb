class AcesContainer < Formula
  desc "Reference implementation of SMPTE ST2065-4"
  homepage "https://github.com/ampas/aces_container"
  url "https://github.com/ampas/aces_container/archive/v1.0.1.tar.gz"
  sha256 "c1a5c08a128911faa5c8a1f9189c566178f19979ab627346238272c54343390a"

  bottle do
    cellar :any
    sha256 "658b485aa9ef08a48aeaf8dec5945e0941afc73af04a422f367292de46594e7b" => :el_capitan
    sha256 "11fe1861bab321e0276be40db1cae10df745d89917dcce7bc98ee0221bb34c10" => :yosemite
    sha256 "80dfdcb569776021042666dfa04cca7c0da75a68926a32b9a2d320e3596bbe0a" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
