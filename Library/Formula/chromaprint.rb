class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://bitbucket.org/acoustid/chromaprint/downloads/chromaprint-1.2.tar.gz"
  sha256 "822b8949a322ac04c6f8a3ed78f5e689bcc493c6ca0972bf627c913c8430031a"

  bottle do
    cellar :any
    sha256 "aff7ca3827063d2b8a6489022f9dfa785593922ffcc144ab8b90b6f8fbbd7d81" => :el_capitan
    sha256 "fa9422d4e83a696110f9880e8b70330e92c36d964f67fc3e50c21a94a473b549" => :yosemite
    sha256 "f909650189b87ed9f26ec1428fa2787688a0e36d677a5e4f0a605b209e128ca5" => :mavericks
    sha256 "a15989c1b685ce333aeec347c20d1f903533bc478f4ac1f34bc6da9c0cd1bd29" => :mountain_lion
  end

  option "without-examples", "Don't build examples (including fpcalc)"

  depends_on "cmake" => :build
  depends_on "ffmpeg" if build.with? "examples"

  def install
    args = std_cmake_args
    args << "-DBUILD_EXAMPLES=ON" if build.with? "examples"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "#{bin}/fpcalc", test_fixtures("test.mp3") if build.with? "examples"
  end
end
