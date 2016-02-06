class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://bitbucket.org/acoustid/chromaprint/downloads/chromaprint-1.3.tar.gz"
  sha256 "3dc3ff97abdce63abc1f52d5f5f8e72c22f9a690dd6625271aa96d3a585b695a"

  bottle do
    cellar :any
    sha256 "8bd9aad258b4695f87e2a5cea3169981d6feb8fdb007a673c19b9f56df642f7d" => :el_capitan
    sha256 "120f5118d435b728c8284211543218240c86f4be1a05b7e9a50b3e91222e485d" => :yosemite
    sha256 "830db349d696186e6c6c660848cd0eb75451a40801677e2a1997eab202ba3cc5" => :mavericks
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
