class Commonmark < Formula
  homepage "http://commonmark.org"
  url "https://github.com/jgm/cmark/archive/0.18.3.tar.gz"
  sha256 "493a29765b6b72b7cac9acca9b5be1e34828345068a1b1c17f8e004b786d55de"

  bottle do
    cellar :any
    sha256 "a7b4476a97935bb0b1993f819bdffc90a07d18adf826a0908fa14d19718a8a4a" => :yosemite
    sha256 "533429569e11bd54dcd80fb091abf7d38fd6ac973ead92b716244f8647804a81" => :mavericks
    sha256 "dccc6b129174b567f94c849d079c73c9fe609855f3423048f94a2bd858f18345" => :mountain_lion
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
