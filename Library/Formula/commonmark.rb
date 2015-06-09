class Commonmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "http://commonmark.org"
  url "https://github.com/jgm/cmark/archive/0.20.0.tar.gz"
  sha256 "c8f77eaf5389968cd5737439693f2c8d43606969d5c4674d443e70a90920f48b"

  bottle do
    cellar :any
    sha256 "181be5778b214828ed9c95bcb11d40864cbdeed93abf12ab9e2cbcf725c7516c" => :yosemite
    sha256 "9d8edde15d2c5d8fc45a17af25379dc08eb9a2acd818a2064c035f91c4939ede" => :mavericks
    sha256 "5ad82a1f6ee5a88647b967bea985f5dc7f38f277bbfbc2dccfb17875dac138c0" => :mountain_lion
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
