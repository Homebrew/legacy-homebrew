class Ccextractor < Formula
  homepage "http://ccextractor.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ccextractor/ccextractor/0.75/ccextractor.src.0.75.zip"
  sha1 "c36f8eadb2074d88782d6628e07c762e80e4c31c"
  head "https://github.com/ccextractor/ccextractor.git"
  revision 1

  depends_on "cmake" => :build
  depends_on "libpng"

  bottle do
    cellar :any
    sha1 "12fc81b745160eaf4d664907defe87230ffa022e" => :yosemite
    sha1 "4e4775826383cc891cb63f9f33f5d5a0f74ff5ac" => :mavericks
    sha1 "9eefc9ce1714e675a9ef01841e79b6b72170173d" => :mountain_lion
  end

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
