class Commonmark < Formula
  homepage "http://commonmark.org"
  url "https://github.com/jgm/CommonMark/archive/0.15.tar.gz"
  sha1 "877665a96fdc5fcc42ec2cd605d8535344a27b72"

  bottle do
    cellar :any
    sha1 "fbaebb5f33ffad7deb3b744d37e00bfab8d6251a" => :yosemite
    sha1 "3cd4d72d841ff4e95cb3fac25451b2979161b5a1" => :mavericks
    sha1 "f67567a2bf4bf4f619b3631a1c575f16a58df25c" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on :python3 => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      ENV.deparallelize # https://github.com/jgm/CommonMark/issues/279
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
