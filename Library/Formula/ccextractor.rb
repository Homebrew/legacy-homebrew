class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "http://ccextractor.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ccextractor/ccextractor/0.78/ccextractor.src.0.78.zip"
  sha256 "95c40f788c803c1932f5678d10b4b63e6650290c35fa2328882af551ec6d3fc9"
  head "https://github.com/ccextractor/ccextractor.git"

  bottle do
    cellar :any
    revision 1
    sha256 "08ca272b7c1ab7ee1945654a896282ed6c5f19651bbc5dc02e6ad7d71039456c" => :el_capitan
    sha256 "10ad588c435ec6b4a0c1f6f8dea8603024100f404727b30c01e939fdc16f88ad" => :yosemite
    sha256 "f353febd41be9199e791aedf219fb15d506a10928a86782c7afeab766d470a2f" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "libpng"

  def install
    ENV.append "LDFLAGS", "-lpng"
    system "cmake", "src", *std_cmake_args
    system "make"
    system "make", "install"
    (share/"examples").install "docs/ccextractor.cnf.sample"
  end

  test do
    touch testpath/"test"
    system bin/"ccextractor", "test"
    assert File.exist?("test.srt")
  end
end
