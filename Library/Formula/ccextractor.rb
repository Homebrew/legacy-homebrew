class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "http://ccextractor.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ccextractor/ccextractor/0.78/ccextractor.src.0.78.zip"
  sha256 "95c40f788c803c1932f5678d10b4b63e6650290c35fa2328882af551ec6d3fc9"
  head "https://github.com/ccextractor/ccextractor.git"

  bottle do
    cellar :any
    sha256 "1e596a6366ac48c9d42b880516b574a81bb35f331e511e2c01cf0b5a39906c9a" => :el_capitan
    sha256 "ad7639a5c96bd1e7f94234dce0fbea2685e81d1ea2a853c6e09b7de5059d0c52" => :yosemite
    sha256 "1d13697115f36df12c3eb5633527369f65324b30cb89ba4e13c1bddd3d196011" => :mavericks
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
