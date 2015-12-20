class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "http://ccextractor.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ccextractor/ccextractor/0.78/ccextractor.src.0.78.zip"
  sha256 "95c40f788c803c1932f5678d10b4b63e6650290c35fa2328882af551ec6d3fc9"
  head "https://github.com/ccextractor/ccextractor.git"

  bottle do
    cellar :any
    revision 1
    sha256 "58a191a71de18ec0dd05dc87d939ec77734ae56be0a5ddb474ee0752daeb272d" => :el_capitan
    sha256 "ccefb5fb2a0ac270ed2e59bcffdb9510f583b2b71134b51b1cb521fb04db997d" => :yosemite
    sha256 "d912fde7ea48d6c50a2c675d851e2ca5c2edd52b06074e126ab708e63f7e7e8b" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "libpng"

  def install
    system "cmake", "src", *std_cmake_args
    system "make"
    system "make", "install"
    (share/"examples").install "docs/ccextractor.cnf.sample"
  end

  test do
    touch testpath/"test"
    system "ccextractor", "test"
    assert File.exist? "test.srt"
  end
end
