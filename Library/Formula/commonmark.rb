class Commonmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "http://commonmark.org"
  url "https://github.com/jgm/cmark/archive/0.25.2.tar.gz"
  sha256 "530ae56d81a370ce29ed77fd3a34628c94277320f23657f5efb402283716f29b"

  bottle do
    cellar :any
    sha256 "c68f34e2a043f49b2d96fdeb1107408927efb76c64ca9487b904e1fc24dcefe7" => :el_capitan
    sha256 "4682e77d2c07cbfa7fe427362f97d4f082ac163154de34d64f2aeb7affde0a17" => :yosemite
    sha256 "7b9cab994177974c160c453df167961f221fa99ec12f255f29b608c981139af8" => :mavericks
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
