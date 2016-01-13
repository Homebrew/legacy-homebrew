class Commonmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "http://commonmark.org"
  url "https://github.com/jgm/cmark/archive/0.24.0.tar.gz"
  sha256 "6408e8019585d28518521c3cb8036651296c04ca0ea56fe105b2ed1bb27b0bdb"

  bottle do
    cellar :any
    sha256 "28d0e45a0755275fe59597158e7026bed72bca866e531fae794fb47290f53e23" => :el_capitan
    sha256 "9bf7f8db124ffc586ccf34f06d03924fd142f4943c5d0cd5c8e062008fdf48ea" => :yosemite
    sha256 "534f6fbf85d73d1f9549a43926be1c0d5186e5f435756f0bded964007326d07c" => :mavericks
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
