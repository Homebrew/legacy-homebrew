class Commonmark < Formula
  homepage "http://commonmark.org"
  url "https://github.com/jgm/CommonMark/archive/0.15.tar.gz"
  sha1 "877665a96fdc5fcc42ec2cd605d8535344a27b72"

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
