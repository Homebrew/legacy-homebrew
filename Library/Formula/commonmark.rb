class Commonmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "http://commonmark.org"
  url "https://github.com/jgm/cmark/archive/0.24.0.tar.gz"
  sha256 "6408e8019585d28518521c3cb8036651296c04ca0ea56fe105b2ed1bb27b0bdb"

  bottle do
    cellar :any
    sha256 "8cbb812bf19210a6eaf8ca1cff6b13d374dca0f268cc101ef9d8e27268aee0a6" => :el_capitan
    sha256 "f041364e048da475d5e62a3e64becc34c2f7fd0f3c234daf568256bfc6833d6a" => :yosemite
    sha256 "22012af91e9e4dfcb8b7604f4d9ca364c5cbcfa2f877850196229be73c112092" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on :python3 => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
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
