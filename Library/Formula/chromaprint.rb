class Chromaprint < Formula
  homepage "https://acoustid.org/chromaprint"
  url "https://bitbucket.org/acoustid/chromaprint/downloads/chromaprint-1.1.tar.gz"
  sha256 "6b14d7ea4964581b73bd3f8038c8857c01e446421c1ae99cbbf64de26b47cd12"

  bottle do
    cellar :any
    sha1 "4cc5cb817710059239610681dfffa91e687e14b0" => :mavericks
    sha1 "3681f1500bae864b7bbbac8d01abe9f1cd0bea50" => :mountain_lion
    sha1 "93e7e29179d55c4d35c7993fd091c46d7aec622a" => :lion
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
end
