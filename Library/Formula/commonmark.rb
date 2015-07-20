class Commonmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "http://commonmark.org"
  url "https://github.com/jgm/cmark/archive/0.21.0.tar.gz"
  sha256 "dc852412e45489b823392dee334f2db47adbd757b0ac08bc026383627fc13f6e"

  bottle do
    cellar :any
    sha256 "4df14ae8b336a43671f6282118a484f0977b0401e178a5e6b087ed75a0d561d3" => :yosemite
    sha256 "c834a27b2ad8dcd0fb853f1e08db8b2fa8e2b32bdc7e868b80b2688cf6a385f5" => :mavericks
    sha256 "d5b423c3fec6ead12a244aed47f277bb5dd284939409d8d4704cd89663af30ed" => :mountain_lion
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
