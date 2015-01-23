class Commonmark < Formula
  homepage "http://commonmark.org"
  url "https://github.com/jgm/CommonMark/archive/0.16.tar.gz"
  sha1 "932c3af5c7357070b8f3d2f418b78e1f56f6df19"

  bottle do
    cellar :any
    sha1 "685e8f6613827331a8d4c907eb04e69efb32c666" => :yosemite
    sha1 "dc1d444e0c077d3432f004f6b310680af0796681" => :mavericks
    sha1 "fdc2391df0e2253af799ad594c3c35305b0657d0" => :mountain_lion
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
