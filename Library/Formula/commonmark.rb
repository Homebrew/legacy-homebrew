class Commonmark < Formula
  homepage "http://commonmark.org"
  url "https://github.com/jgm/cmark/archive/0.17.tar.gz"
  sha1 "a0bce3d321822ca96f312e9210fc8cd149a8f527"

  bottle do
    cellar :any
    sha1 "c02997d6624c6a9ef4e627ff789cb83127a17b97" => :yosemite
    sha1 "9777bbeb2d36fd1fc901261167af0452ecd21622" => :mavericks
    sha1 "af4136806400ffcf35f984fbd52f16b5bf08f2e6" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on :python3 => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    test_input = "*hello, world*\n"
    expected_output = "<p><em>hello, world</em></p>\n"
    test_output = `/bin/echo -n "#{test_input}" | #{bin}/cmark`
    assert_equal expected_output, test_output
  end
end
