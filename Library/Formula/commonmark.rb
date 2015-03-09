class Commonmark < Formula
  homepage "http://commonmark.org"
  url "https://github.com/jgm/cmark/archive/0.18.tar.gz"
  sha1 "dc45a70aec89c0a428321b8d0d29ee4933a7d562"

  bottle do
    cellar :any
    sha1 "d6649e3b9cc6a7a05c4bf37b5b77a66b0524dfa0" => :yosemite
    sha1 "3108842f9e69cfcf0a3a9c3d29f1e638f73b12dc" => :mavericks
    sha1 "9a06df359b9c7ba2f7ebf8048d9c6c59efdee04c" => :mountain_lion
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
