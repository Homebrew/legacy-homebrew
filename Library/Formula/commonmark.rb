class Commonmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "http://commonmark.org"
  url "https://github.com/jgm/cmark/archive/0.23.0.tar.gz"
  sha256 "87d289965066fce7be247d44c0304af1b20817dcc1b563702302ae33f2be0596"

  bottle do
    cellar :any
    sha256 "1eb4a3d846123344c005233eb85f18beefb0734322f7412b34666385f4b52265" => :el_capitan
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
