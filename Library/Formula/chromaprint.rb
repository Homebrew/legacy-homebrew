class Chromaprint < Formula
  homepage "https://acoustid.org/chromaprint"
  url "https://bitbucket.org/acoustid/chromaprint/downloads/chromaprint-1.2.tar.gz"
  sha256 "822b8949a322ac04c6f8a3ed78f5e689bcc493c6ca0972bf627c913c8430031a"

  bottle do
    cellar :any
    sha256 "ef34e1c1bb3016fa27ea0bba10a01d65c0f6c60737a7fbb7b8ffc08156c54815" => :yosemite
    sha256 "3f78eb0feb44cd6375fae0de9f51bd3a3354b69a7d3e066231198ac4d39c38fe" => :mavericks
    sha256 "46f4596410d895c122bb306154ac6eec6d03008c40206183679888a62b7cb1a7" => :mountain_lion
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
