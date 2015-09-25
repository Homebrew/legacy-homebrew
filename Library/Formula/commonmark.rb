class Commonmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "http://commonmark.org"
  url "https://github.com/jgm/cmark/archive/0.22.0.tar.gz"
  sha256 "a45956e6ee491d71e9271ddeb09364599a136b8956d219f0168dd6042f6f791b"

  bottle do
    cellar :any
    sha256 "dd40ba6bf439e6232c4c46347be0eefc2bf71577400993a480d8b6beee9349a4" => :yosemite
    sha256 "810716f1e9da14265ac4d4f1c9c13270929a7291199ff80f399774d7ad94d892" => :mavericks
    sha256 "89779b880634f3052c1d2f50298d93e00a1347d83768fb1eeae46aa39e02136f" => :mountain_lion
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
