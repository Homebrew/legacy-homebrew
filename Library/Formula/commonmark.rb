class Commonmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "http://commonmark.org"
  url "https://github.com/jgm/cmark/archive/0.19.0.tar.gz"
  sha256 "25547326e24595da0ec3be5b8d2b2d1fff9d9943ab68ae1cc0dc4cc79d2c22e4"

  bottle do
    cellar :any
    sha256 "3fb2b4a8834789afbd39c8f48809ba5acd5297807c66530148be5b8baeb8adef" => :yosemite
    sha256 "ad8c11f6fd8a9063caedc80f7732ad18be279b78c6fcc76316d6fdae40992923" => :mavericks
    sha256 "7b5cbadf794790af2168196ad47844b81977885c6e959d3c93e7ca8451816b7b" => :mountain_lion
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
