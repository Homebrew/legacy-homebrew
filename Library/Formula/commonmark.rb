class Commonmark < Formula
  homepage "http://commonmark.org"
  url "https://github.com/jgm/cmark/archive/0.18.3.tar.gz"
  sha256 "493a29765b6b72b7cac9acca9b5be1e34828345068a1b1c17f8e004b786d55de"

  bottle do
    cellar :any
    sha256 "c33ecffda8c5daed16e14d37dcd045a844975e1c86d766a403927236d7c7a648" => :yosemite
    sha256 "6dc175f2ccd1dafe9e1eaaedd21287897851f7ea522b0b484c1fb2e611c9cb57" => :mavericks
    sha256 "ff29a169eb4f7eeaadd68ebdae251509b6aff77f5a228976e160d19438561460" => :mountain_lion
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
