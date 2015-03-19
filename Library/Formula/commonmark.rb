class Commonmark < Formula
  homepage "http://commonmark.org"
  url "https://github.com/jgm/cmark/archive/0.18.1.tar.gz"
  sha1 "e8885824134ef77ba8be428f1d2cac47c716045b"

  bottle do
    cellar :any
    sha256 "7568ed89b39e9254c16058e035becf3a1fc6b21ef10627e3bca6e640de4dd78d" => :yosemite
    sha256 "41f843594c8663e39408d9e2c088036cf41d9e76a8441463ee527a52998e9deb" => :mavericks
    sha256 "a9fe72757190f012a7c500c867504f8e3fabad051d88d4964b0c08a56bdf757b" => :mountain_lion
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
